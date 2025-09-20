gnome = import('gnome')

cc = meson.get_compiler('c')
valac = meson.get_compiler('vala')
sassc = find_program('sass', required: true)

deps = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('gio-unix-2.0'),
  dependency('gtk4'),
  dependency('gtk4-layer-shell-0'),
  dependency('libadwaita-1'),
  dependency('libnm'),
  dependency('astal-io-0.1'),
  dependency('astal-4-4.0'),
  dependency('astal-apps-0.1'),
  dependency('astal-battery-0.1'),
  dependency('astal-bluetooth-0.1'),
  dependency('astal-brightness-0.1'),
  dependency('astal-mpris-0.1'),
  dependency('astal-network-0.1'),
  dependency('astal-notifd-0.1'),
  dependency('astal-wireplumber-0.1'),
  cc.find_library('m'),
]

css = custom_target(
  'sass',
  input: 'gtk/style.scss',
  output: 'style.css',
  command: [sassc, '@INPUT@', '@OUTPUT@'],
)

sources = files(
  'application.vala',
  'bar.vala',
  'mpris_player.vala',
  'control_panel.vala',
  'notification.vala',
  'notification_popups.vala',
  'launcher_application.vala',
  'launcher.vala',
  'osd_popups.vala',
)

sources += gnome.compile_resources(
  'resources',
  'gresource.xml',
  dependencies: [css],
  source_dir: 'src',
)

executable(
  'shell',
  sources,
  dependencies: deps,
  install: true,
)
