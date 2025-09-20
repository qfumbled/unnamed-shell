[GtkTemplate(ui = "/launcher-application.ui")]
class LauncherApplication : Gtk.ListBoxRow {
  private AstalApps.Application? application;

  [GtkChild] unowned Gtk.Image icon;
  [GtkChild] unowned Gtk.Label name;
  [GtkChild] unowned Gtk.Label description;

  public LauncherApplication(AstalApps.Application application) {
    if (this.application == null)
      this.application = application;

    icon.set_visible(application.icon_name != null);
    icon.set_from_icon_name(application.icon_name);

    name.set_visible(application.name != "");
    name.set_label(application.name);

    description.set_visible(application.description != "");
    description.set_label(application.description);
  }
}
