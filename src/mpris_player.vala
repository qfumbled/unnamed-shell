[GtkTemplate(ui = "/mpris-player.ui")]
class MprisPlayer : Gtk.Box {
  private AstalMpris.Player? player;

  [GtkChild] unowned Gtk.Image cover_art;
  [GtkChild] unowned Gtk.Label title;
  [GtkChild] unowned Gtk.Label artists;
  [GtkChild] unowned Gtk.Button controls_previous_button;
  [GtkChild] unowned Gtk.Button controls_play_pause_button;
  [GtkChild] unowned Gtk.Button controls_next_button;

  public MprisPlayer(AstalMpris.Player player) {
    if (this.player == null)
      this.player = player;

    sync_cover_art_image();
    player.notify["art-url"].connect(() => sync_cover_art_image());

    player.bind_property("title", title, "label", BindingFlags.SYNC_CREATE);

    sync_artists_label();
    player.notify["artists"].connect(() => sync_artists_label());

    controls_previous_button.clicked.connect(() => player.previous());
    player.bind_property("can-go-previous", controls_previous_button, "sensitive", BindingFlags.SYNC_CREATE);

    controls_play_pause_button.clicked.connect(() => player.play_pause());
    sync_controls_play_pause_button_icon();
    player.notify["playback-status"].connect(() => sync_controls_play_pause_button_icon());

    controls_next_button.clicked.connect(() => player.next());
    player.bind_property("can-go-next", controls_next_button, "sensitive", BindingFlags.SYNC_CREATE);
  }

  private void sync_cover_art_image() {
    cover_art.set_from_file(player.art_url.replace("file://", ""));
  }

  private void sync_artists_label() {
    artists.set_label(string.joinv(", ", player.artists));
  }

  private void sync_controls_play_pause_button_icon() {
    if (player.playback_status == AstalMpris.PlaybackStatus.PLAYING) {
      controls_play_pause_button.set_icon_name("media-playback-pause-symbolic");
    } else {
      controls_play_pause_button.set_icon_name("media-playback-start-symbolic");
    }
  }
}
