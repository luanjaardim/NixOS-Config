const hyprland = await Service.import("hyprland")
const notifications = await Service.import("notifications")
const mpris = await Service.import("mpris")
const audio = await Service.import("audio")
const battery = await Service.import("battery")
const network = await Service.import('network')
const systemtray = await Service.import("systemtray")
import { applauncher } from "./applauncher.js"
import { utilities_btns } from "./utilities_btns.js"
import { NotificationPopups } from "./notifications.js"

const date = Variable("", {
    poll: [5000, 'date "+%H:%M %e %b"'],
})

const divide = ([total, free]) => free / total

const cpu = Variable(0, {
    poll: [2000, 'top -b -n 1', out => divide([100, out.split('\n')
        .find(line => line.includes('Cpu(s)'))
        .split(/\s+/)[1]
        .replace(',', '.')])],
})

const ram = Variable(0, {
    poll: [2000, 'free', out => divide(out.split('\n')
        .find(line => line.includes('Mem:'))
        .split(/\s+/)
        .splice(1, 2))],
})

const WifiIndicator = () => {
    const showName = Variable(false)
    return Widget.Button({
        onHoverLost: async () => showName.value = false,
        onHover: async () => showName.value = true,
        onClicked: () => Utils.execAsync('kitty nmtui'),
        child: Widget.Box({
            children: [
                Widget.Icon({
                    css: 'margin-right: 5px;',
                    icon: network.wifi.bind('icon_name'),
                }),
                Widget.Label({
                    label: network.wifi.bind('ssid')
                        .as(ssid => ssid || 'Unknown'),
                    visible: showName.bind(),
                }),
            ],
        })
    })
}

const WiredIndicator = () => Widget.Icon({
    icon: network.wired.bind('icon_name'),
})

const NetworkIndicator = () => Widget.Stack({
    children: {
        wifi: WifiIndicator(),
        wired: WiredIndicator(),
    },
    shown: network.bind('primary').as(p => p || 'wifi'),
})

// widgets can be only assigned as a child in one container
// so to make a reuseable widget, make it a function
// then you can simply instantiate one by calling it

const Workspaces = () => {
    // Function to move to the 'ws' workspace
    const dispatch = ws => hyprland.messageAsync(`dispatch workspace ${ws}`);

    return Widget.EventBox({
	onScrollUp: () => dispatch('+1'),
	onScrollDown: () => dispatch('-1'),
	child: Widget.Box({
            class_name: "workspaces",
	    children: [...Array(5)].map((_, i) => {
		const id = i + 1;
		return Widget.Button({
		    onClicked: (event) => dispatch(id),
		    label: hyprland.active.workspace.bind("id").as(
			activeId => (activeId == id ? "" : "")
		    )
		})
	    })
	})
    })
}


function ClientTitle() {
    const c = hyprland.active.client.bind("class")
    return Widget.Label({
        class_name: c.as(s => s.length == 0 ? "" : "client-title"),
        label: c.as( s => s.length != 0 ? s[0].toUpperCase() + s.slice(1) : ""),
    })
}


function Clock() {
    return Widget.Label({
        class_name: "clock",
        label: date.bind(),
    })
}

function Media() {
    const label = Utils.watch("", mpris, "player-changed", () => {
        if (mpris.players[0]) {
            const { track_artists, track_title } = mpris.players[0]
            const music = `${track_artists.join(", ")} - ${track_title}`
            const maxLen = 50;
            return music.length > maxLen ? `${music.slice(0, maxLen-3)}...` : music
        } else {
            return "Nothing is playing"
        }
    })

    return Widget.Button({
        class_name: label.as( s => s.length == 0 ? "" : "media"),
        onPrimaryClick: () => mpris.getPlayer("")?.playPause(),
        // Go to next song
        onSecondaryClick: () => mpris.getPlayer("")?.next(),
        onScrollUp: () => mpris.getPlayer("")?.next(),
        // Go to previous song
        onMiddleClick: () => mpris.getPlayer("")?.previous(),
        onScrollDown: () => mpris.getPlayer("")?.previous(),
        child: Widget.Label({ label }),
    })
}

export function custom_revealer(trigger, slider, custom_class = '', on_primary_click = () => { })
{
    const revealer = Widget.Revealer({
        revealChild: false,
        transitionDuration: 500,
        transition: 'slide_right',
        child: slider,
    });

    const eventBox = Widget.EventBox({
        class_name: "custom-revealer button" + custom_class,
        on_hover: async (self) =>
        {
            revealer.reveal_child = true
        },
        on_hover_lost: async () =>
        {
            revealer.reveal_child = false
        },
        on_primary_click: on_primary_click,
        child: Widget.Box({
            children: [trigger, revealer],
        }),
    });

    return eventBox;
}

function InfoProgress(icon, value) {
    return Widget.Box({
        children: [
            icon,
            Widget.CircularProgress({
                class_name: "info_progress",
                value,
            })
        ],
    })

}

function Volume() {
    const icons = {
        101: "overamplified",
        67: "high",
        34: "medium",
        1: "low",
        0: "muted",
    }

    function getIcon() {
        const icon = audio.speaker.is_muted ? 0 : [101, 67, 34, 1, 0].find(
            threshold => threshold <= audio.speaker.volume * 100)

        return `audio-volume-${icons[icon]}-symbolic`
    }

    const icon = Widget.Icon({
        icon: Utils.watch(getIcon(), audio.speaker, getIcon),
    })

    const slider = Widget.Slider({
        hexpand: true,
        draw_value: false,
        onChange: ({ value }) => audio.speaker.volume = value,
        setup: self => self.hook(audio.speaker, () => {
            self.value = audio.speaker.volume || 0
        }),
    })

    return custom_revealer(icon, slider)
}

function Brightness() {
    const curBright = Variable(0)
    const maxBrightLevel = Number(Utils.exec("brightnessctl max"))
    const updateBrightness = () => curBright.setValue(Number(Utils.exec("brightnessctl get")));

    const fileToWatch = Utils.exec("/usr/bin/env bash -c 'ls /sys/class/backlight/*/brightness | head -n1'")
    const monitorFile = Utils.monitorFile(fileToWatch, updateBrightness)

    const icon = Widget.Icon({ icon: 'display-brightness-symbolic' })

    const slider = Widget.Slider({
        hexpand: true,
        draw_value: false,
        onChange: ({ value }) => Utils.execAsync(`brightnessctl set ${Math.floor(value * 100)}%`),
        setup: self => self.hook(curBright, () => {
            self.value = curBright.getValue() / maxBrightLevel
        }),
    })
    updateBrightness()  // Updating the value of the Variable for the first time.

    return custom_revealer(icon, slider)
}


function BatteryLabel() {
    const value = battery.bind("percent").as(p => p > 0 ? p / 100 : 0)
    const icon = battery.bind("percent").as(p =>
        `battery-level-${Math.floor(p / 10) * 10}-symbolic`)

    return Widget.Box({
        class_name: "battery",
        visible: battery.bind("available"),
        children: [
            Widget.Icon({ icon }),
            Widget.CircularProgress({
                class_name: "info_progress",
                value,
            }),
        ],
        setup: self => self.poll(10000, self => {
            if(Number(battery.percent) < 20 && !battery.charging) {
                Utils.execAsync(`notify-send "Battery Low"`)
            } else if(Number(battery.percent) == 100) {
                Utils.execAsync(`notify-send "Battery Full"`)
            }
        }),
    })
}


function SysTray() {
    const items = systemtray.bind("items")
        .as(items => items.map(item => Widget.Button({
            class_name: "systray",
            child: Widget.Icon({ icon: item.bind("icon") }),
            on_primary_click: (_, event) => item.activate(event),
            on_secondary_click: (_, event) => item.openMenu(event),
            tooltip_markup: item.bind("tooltip_markup"),
        })))

    return Widget.Box({
        children: items,
    })
}


// layout of the bar
function Left() {
    return Widget.Box({
        children: [
            Workspaces(),
            ClientTitle(),
        ],
    })
}

function Center() {
    return Widget.Box({
        spacing: 8,
        children: [
            Media(),
        ],
    })
}

function Right() {
    return Widget.Box({
        hpack: "end",
        spacing: 10,
        children: [
            Widget.Box({
                class_name: "utils",
                spacing: 10,
                children: [
                    SysTray(),
                    Brightness(),
                    Volume(),
                    InfoProgress(Widget.Label({label: "CPU"}), cpu.bind()),
                    InfoProgress(Widget.Label({label: "RAM"}), ram.bind()),
                    BatteryLabel(),
                    NetworkIndicator(),
                ]
            }),
            Clock(),
        ],
    })
}

function Bar(monitor = 0) {
    return Widget.Window({
        name: `bar-${monitor}`, // name has to be unique
        class_name: "bar",
        monitor,
        anchor: ["top", "left", "right"],
        exclusivity: "exclusive",
        child: Widget.CenterBox({
            start_widget: Left(),
            center_widget: Center(),
            end_widget: Right(),
        }),
    })
}

const scss = App.configDir + "/style.scss";
const css = App.configDir + "/style.css";

Utils.exec(`sass ${scss} ${css}`);

App.config({
    style: css,
    windows: [
        Bar(),
        applauncher,
        utilities_btns,
        NotificationPopups(),
        // you can call it, for each monitor
        // Bar(0),
        // Bar(1)
    ],
})

export { }
