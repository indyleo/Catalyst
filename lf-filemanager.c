/*
 * lf-filemanager.c - org.freedesktop.FileManager1 handler that opens lf.
 *
 * Browsers, editors and other GUI apps call this service for "Show in folder".
 * Each requested item opens in its own terminal window running lf, with the
 * file selected (ShowItems / ShowItemProperties) or the folder opened
 * (ShowFolders).
 */
#define _GNU_SOURCE
#include <ctype.h>
#include <dbus/dbus.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define BUS_NAME "org.freedesktop.FileManager1"
#define MAX_ARGS 32
#define MAX_ITEMS 8 /* never open more than this many windows per call */

/* file:///a%20b/c -> /a b/c. Returns a malloc'd string, or NULL if not a file
 * URI. */
static char *uri_to_path(const char *uri) {
  if (strncmp(uri, "file://", 7) != 0)
    return NULL;
  const char *p = uri + 7;
  if (*p != '/') { /* skip an authority such as file://localhost/... */
    p = strchr(p, '/');
    if (!p)
      return NULL;
  }
  char *out = malloc(strlen(p) + 1);
  if (!out)
    return NULL;
  char *o = out;
  while (*p) {
    if (p[0] == '%' && isxdigit((unsigned char)p[1]) &&
        isxdigit((unsigned char)p[2])) {
      char hex[3] = {p[1], p[2], 0};
      *o++ = (char)strtol(hex, NULL, 16);
      p += 3;
    } else {
      *o++ = *p++;
    }
  }
  *o = '\0';
  return out;
}

/* Open lf on `path` in a new terminal window. No shell involved, so file names
 * with quotes, spaces or $() are passed through untouched. */
static void launch(const char *path) {
  char term[512];
  const char *env = getenv("FILEMANAGER_TERM");
  if (env && *env) {
    snprintf(term, sizeof term, "%s", env);
  } else {
    const char *t = getenv("TERMINAL");
    snprintf(term, sizeof term, "%s -e", t && *t ? t : "alacritty");
  }

  char *argv[MAX_ARGS];
  int argc = 0;
  for (char *tok = strtok(term, " \t"); tok && argc < MAX_ARGS - 3;
       tok = strtok(NULL, " \t"))
    argv[argc++] = tok;
  if (argc == 0)
    return;
  argv[argc++] = "lf";
  argv[argc++] = (char *)path;
  argv[argc] = NULL;

  pid_t pid = fork();
  if (pid == 0) {
    setsid();
    execvp(argv[0], argv);
    _exit(127);
  }
}

static void show(DBusMessage *msg) {
  DBusMessageIter iter, array;
  if (!dbus_message_iter_init(msg, &iter) ||
      dbus_message_iter_get_arg_type(&iter) != DBUS_TYPE_ARRAY)
    return;
  dbus_message_iter_recurse(&iter, &array);

  int opened = 0;
  while (dbus_message_iter_get_arg_type(&array) == DBUS_TYPE_STRING &&
         opened < MAX_ITEMS) {
    const char *uri;
    dbus_message_iter_get_basic(&array, &uri);
    char *path = uri_to_path(uri);
    if (path) {
      launch(path);
      free(path);
      opened++;
    }
    dbus_message_iter_next(&array);
  }
}

static DBusHandlerResult on_message(DBusConnection *conn, DBusMessage *msg,
                                    void *data) {
  (void)data;

  if (!dbus_message_is_method_call(msg, BUS_NAME, "ShowItems") &&
      !dbus_message_is_method_call(msg, BUS_NAME, "ShowFolders") &&
      !dbus_message_is_method_call(msg, BUS_NAME, "ShowItemProperties"))
    return DBUS_HANDLER_RESULT_NOT_YET_HANDLED; /* libdbus replies UnknownMethod
                                                 */

  show(msg);

  DBusMessage *reply = dbus_message_new_method_return(msg);
  if (reply) {
    dbus_connection_send(conn, reply, NULL);
    dbus_message_unref(reply);
    dbus_connection_flush(conn);
  }
  return DBUS_HANDLER_RESULT_HANDLED;
}

int main(void) {
  signal(SIGCHLD, SIG_IGN); /* the lf windows are not ours to reap */

  DBusError err;
  dbus_error_init(&err);
  DBusConnection *conn = dbus_bus_get(DBUS_BUS_SESSION, &err);
  if (!conn) {
    fprintf(stderr, "lf-filemanager: no session bus: %s\n", err.message);
    return 1;
  }

  int r = dbus_bus_request_name(
      conn, BUS_NAME,
      DBUS_NAME_FLAG_REPLACE_EXISTING | DBUS_NAME_FLAG_DO_NOT_QUEUE, &err);
  if (dbus_error_is_set(&err) || r != DBUS_REQUEST_NAME_REPLY_PRIMARY_OWNER) {
    fprintf(
        stderr,
        "lf-filemanager: could not own %s (another file manager running?)\n",
        BUS_NAME);
    return 1;
  }

  dbus_connection_add_filter(conn, on_message, NULL, NULL);
  while (dbus_connection_read_write_dispatch(conn, -1))
    ;
  return 0;
}
