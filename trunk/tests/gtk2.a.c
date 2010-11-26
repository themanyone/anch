/* #!/usr/local/bin/anch -run $(pkg-config --cflags --libs gtk+-2.0) */
/* Convert to C with Anchor http://freshmeat.net/projects/anchor */
#include <gtk/gtk.h>
#define IMAGE "../images/anchor.jpg"
static gboolean delete_event  GtkWidget * widget,
                             GdkEvent * event, gpointer data
    g_print  "delete event occurred\n"
    /* Change TRUE to FALSE and the main window will be destroyed */
    return FALSE
/* Another callback */
static void destroy  GtkWidget * widget, gpointer data
    gtk_main_quit  
/* click callback */
static gboolean button_press_callback  GtkWidget * event_box,
                      GdkEventButton * event, gpointer data
    g_print  "Event box clicked at coordinates %f,%f\n", event->x, event->y
    /* Return FALSE to continue invoking callbacks. */
    return TRUE
/* get image from file */
void create_image  GtkWidget *window
    GtkWidget *image,*event_box
    image = gtk_image_new_from_file  IMAGE
    event_box = gtk_event_box_new()
    gtk_container_add  GTK_CONTAINER(event_box), image
    g_signal_connect  G_OBJECT(event_box),
                     "button_press_event",
                     G_CALLBACK(button_press_callback), image
    gtk_container_add  GTK_CONTAINER(window), event_box
/* main */
int main  int argc, char *argv[]
    GtkWidget *window
#if defined(__GNUC__)
# if defined(__i386__)
    /* Enable Alignment Checking on x86 */
    __asm__("pushf\norl $0x40000,(%esp)\npopf");
# elif defined(__x86_64__)
     /* Enable Alignment Checking on x86_64 */
    __asm__("pushf\norl $0x40000,(%rsp)\npopf");
# endif
#endif
    gtk_init  &argc, &argv
    window = gtk_window_new  GTK_WINDOW_TOPLEVEL
    g_signal_connect  window, "delete-event", G_CALLBACK(delete_event), NULL
    g_signal_connect  window, "destroy", G_CALLBACK(destroy), NULL
    gtk_container_set_border_width  GTK_CONTAINER(window), 10
    create_image  window
    gtk_widget_show_all  window
    gtk_main  
    return 0
