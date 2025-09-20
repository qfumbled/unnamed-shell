[GtkTemplate(ui = "/osd-popups.ui")]
class OsdPopups : Astal.Window {
  private AstalWp.Audio audio = AstalWp.get_default().audio;
  private AstalBrightness.Brightness brightness = AstalBrightness.get_default();

  [GtkChild] unowned Gtk.Box volume_osd;
  [GtkChild] unowned Gtk.Revealer volume_osd_revealer;
  [GtkChild] unowned Gtk.Image volume_osd_icon;
  [GtkChild] unowned Gtk.ProgressBar volume_osd_progress_bar;

  [GtkChild] unowned Gtk.Box brightness_osd;
  [GtkChild] unowned Gtk.Revealer brightness_osd_revealer;
  [GtkChild] unowned Gtk.Image brightness_osd_icon;
  [GtkChild] unowned Gtk.ProgressBar brightness_osd_progress_bar;

  public OsdPopups() {
    anchor = BOTTOM;
    layer = OVERLAY;
    exclusivity = IGNORE;

    {
      var i = 0;
      volume_osd_progress_bar.notify["fraction"].connect(() => {
        volume_osd_revealer.set_reveal_child((bool)(++i));
        Timeout.add(2500, () => {
          volume_osd_revealer.set_reveal_child((bool)(--i));
          return false;
        });
      });
    }

    audio.default_speaker.bind_property("volume-icon", volume_osd_icon, "icon-name", BindingFlags.SYNC_CREATE);
    audio.default_speaker.bind_property("volume", volume_osd_progress_bar, "fraction", BindingFlags.SYNC_CREATE);

    {
      var i = 0;
      brightness_osd_progress_bar.notify["fraction"].connect(() => {
        brightness_osd_revealer.set_reveal_child((bool)(++i));
        Timeout.add(2500, () => {
          brightness_osd_revealer.set_reveal_child((bool)(--i));
          return false;
        });
      });
    }

    brightness_osd_icon.set_from_icon_name("display-brightness-symbolic");
    brightness.bind_property("brightness", brightness_osd_progress_bar, "fraction", BindingFlags.SYNC_CREATE);

    volume_osd.set_css_classes({"pill", "osd"});
    brightness_osd.set_css_classes({"pill", "osd"});

    present();
  }

  public override void size_allocate(int width, int height, int baseline) {
    if (this.child != null)
      this.set_default_size(this.child.get_width(), this.child.get_height());
    base.size_allocate(width, height, baseline);
  }
}
