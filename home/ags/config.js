const hyprland = await Service.import("hyprland")
const notifications = await Service.import("notifications")
const mpris = await Service.import("mpris")
const audio = await Service.import("audio")
const battery = await Service.import("battery")
const systemtray = await Service.import("systemtray")

const date = Variable("", {
    poll: [5000, 'date "+%H:%M %e %b"'],
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
    return Widget.Label({
        class_name: "client-title",
        label: hyprland.active.client.bind("class").as( s => s[0].toUpperCase() + s.slice(1)),
    })
}


function Clock() {
    return Widget.Label({
        class_name: "clock",
        label: date.bind(),
    })
}


// we don't need dunst or any other notification daemon
// because the Notifications module is a notification daemon itself
function Notification() {
    const popups = notifications.bind("popups")
    return Widget.Box({
        class_name: "notification",
        visible: popups.as(p => p.length > 0),
        children: [
            Widget.Icon({
                icon: "preferences-system-notifications-symbolic",
            }),
            Widget.Label({
                label: popups.as(p => p[0]?.summary || ""),
            }),
        ],
    })
}


function Media() {
    const label = Utils.watch("", mpris, "player-changed", () => {
        if (mpris.players[0]) {
            const { track_artists, track_title } = mpris.players[0]
            return `${track_artists.join(", ")} - ${track_title}`
        } else {
            return "Nothing is playing"
        }
    })

    return Widget.Button({
        class_name: "media",
        on_primary_click: () => mpris.getPlayer("")?.playPause(),
        onScrollUp: () => mpris.getPlayer("")?.next(),
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
            Widget.LevelBar({
                widthRequest: 140,
                vpack: "center",
                value,
            }),
        ],
    })
}


function SysTray() {
    const items = systemtray.bind("items")
        .as(items => items.map(item => Widget.Button({
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
        spacing: 8,
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
            Notification(),
        ],
    })
}

function Right() {
    return Widget.Box({
        hpack: "end",
        spacing: 8,
        children: [
            Brightness(),
            Volume(),
            BatteryLabel(),
            Clock(),
            SysTray(),
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

        // you can call it, for each monitor
        // Bar(0),
        // Bar(1)
    ],
})

export { }
