[GtkTemplate(ui = "/notification-popups.ui")]
class NotificationPopups : Astal.Window {
  private AstalNotifd.Notifd notifd = AstalNotifd.get_default();

  [GtkChild] unowned Gtk.Box notification_list;

  public NotificationPopups() {
    anchor = TOP;
    layer = OVERLAY;
    exclusivity = IGNORE;

    notifd.notified.connect((id) => notification_list_add_notification(id));
    notifd.resolved.connect((id) => notification_list_remove_notification(id));

    present();
  }

  private void notification_list_add_notification(uint id) {
    var notification_list_children = notification_list_get_children();
    if (this.get_height() > 300 || notification_list_children.length() >= 5)
      notification_list.remove(notification_list_children.last().data);
    var notification_widget = new Gtk.Revealer() {
      transition_type = Gtk.RevealerTransitionType.SLIDE_DOWN,
      transition_duration = 250,
      child = new Notification(notifd.get_notification(id)),
    };
    notification_widget.set_data("notification-id", id);
    notification_list.prepend(notification_widget);
    notification_widget.set_reveal_child(true);
  }

  private void notification_list_remove_notification(uint id) {
    var notification_list_children = notification_list_get_children();
    notification_list_children.foreach((child) => {
      int notification_id = child.get_data("notification-id");
      if (notification_id == id) {
        ((Gtk.Revealer)child).set_reveal_child(false);
        Timeout.add(((Gtk.Revealer)child).transition_duration, () => {
          notification_list.remove(child);
          return false;
        });
      }
    });
  }

  private List<Gtk.Widget> notification_list_get_children() {
    var child = notification_list.get_first_child();
    var children = new List<Gtk.Widget>();
    while (child != null) {
      children.append(child);
      child = child.get_next_sibling();
    }
    return children;
  }

  public override void size_allocate(int width, int height, int baseline) {
    if (this.child != null)
      this.set_default_size(this.child.get_width(), this.child.get_height());
    base.size_allocate(width, height, baseline);
  }
}
