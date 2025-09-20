[GtkTemplate(ui = "/notification.ui")]
class Notification : Gtk.Box {
  private AstalNotifd.Notification? notification;

  [GtkChild] unowned Gtk.Image image;
  [GtkChild] unowned Gtk.Label title;
  [GtkChild] unowned Gtk.Label body;
  [GtkChild] unowned Gtk.Box actions;

  public Notification(AstalNotifd.Notification notification) {
    if (this.notification == null)
      this.notification = notification;

    var click_gesture = new Gtk.GestureClick() { button = 1 };
    click_gesture.pressed.connect(() => notification.dismiss());
    add_controller(click_gesture);

    image.set_visible(notification.image != null);
    image.set_from_file(notification.image);

    title.set_visible(notification.summary != "");
    title.set_label(notification.summary);

    body.set_visible(notification.body != "");
    body.set_label(notification.body);

    actions.set_visible(notification.actions.length() > 0);
    notification.actions.foreach((action) => {
      var action_button = new Gtk.Button.with_label(action.label) { hexpand = true };
      action_button.clicked.connect(() => notification.invoke(action.id));
      actions.append(action_button);
    });
  }
}
