[GtkTemplate(ui = "/launcher.ui")]
class Launcher : Astal.Window {
  private AstalApps.Apps apps = new AstalApps.Apps();

  [GtkChild] unowned Gtk.ListBox application_list;
  [GtkChild] unowned Gtk.Entry search_entry;

  public Launcher() {
    anchor = NONE;
    layer = OVERLAY;
    exclusivity = IGNORE;
    keymode = ON_DEMAND;

    search_entry.changed.connect(() => {
      application_list_get_children().foreach((app) => {
        AstalApps.Application application = app.get_data("application");
        app.set_visible((bool)application.exact_match(search_entry.text).name);
      });
    });

    search_entry.activate.connect(() => {
      foreach (var app in application_list_get_children()) {
        if (app.visible) {
          app.activate();
          break;
        }
      };
    });

    apps.list.foreach((app) => {
      var application_widget = new LauncherApplication(app);
      application_widget.activate.connect(() => {
        app.launch();
        this.set_visible(false);
      });
      application_widget.set_data("application", app);
      application_list.append(application_widget);
    });
  }

  private List<Gtk.Widget> application_list_get_children() {
    var child = application_list.get_first_child();
    var children = new List<Gtk.Widget>();
    while (child != null) {
      children.append(child);
      child = child.get_next_sibling();
    }
    return children;
  }
}
