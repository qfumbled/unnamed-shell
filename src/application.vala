public class Application : Astal.Application {
  static Application instance;

  public override void activate() {
    apply_css("resource:///style.css", false);
    add_window(new Bar());
    add_window(new ControlPanel());
    add_window(new NotificationPopups());
    add_window(new Launcher());
    add_window(new OsdPopups());
  }

  public static int main() {
    Application.instance = new Application();

    try {
      Application.instance.acquire_socket();
      return Application.instance.run();
    } catch (Error e) {
      error(e.message);
    }
  }
}
