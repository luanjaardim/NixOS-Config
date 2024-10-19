const WINDOW_NAME = "utilities_btns"

const cmdBtn = app => Widget.Button({
    on_clicked: () => {
        App.closeWindow(WINDOW_NAME)
        app.launch()
    },
    attribute: { app },
    child: Widget.Box({
        children: [
            Widget.Icon({
                icon: app.icon_name || "",
                size: 42,
            }),
            Widget.Label({
                class_name: "title",
                label: app.name,
                xalign: 0,
                vpack: "center",
                truncate: "end",
            }),
        ],
    }),
})

const Btns = ({ width = 500, height = 500, spacing = 12 }) => {

    const createBtnIcon = (iconName, cmd) => Widget.Button({
        child: Widget.Icon({
                hexpand: true,
                icon: iconName,
                size: 42,
        }),
        onClicked: () => {
            Utils.execAsync('ags -t utilities_btns')
            Utils.execAsync(cmd)
        },
    })

    // container holding the buttons
    const list = Widget.Box({
        vertical: false,
        children: [
            createBtnIcon('system-shutdown-symbolic', 'shutdown now'),
            createBtnIcon('view-refresh-symbolic', 'reboot'),
            createBtnIcon('weather-clear-night-symbolic', 'systemctl suspend'),
            createBtnIcon('system-log-out-symbolic-rtl', 'hyprctl dispatch exit'),
            createBtnIcon('system-search-symbolic', 'ags -t applauncher'),
        ],
        spacing,
    })

    return Widget.Box({
        css: `margin: ${spacing}px;`,
        children: [
            // wrap the list in a scrollable
            Widget.Scrollable({
                hscroll: "never",
                css: `min-width: ${width}px;`
                    + `min-height: ${height}px;`,
                class_name: "scroll",
                child: list,
            }),
        ],
        setup: self => self.hook(App, (_, windowName, visible) => {
            if (windowName !== WINDOW_NAME)
                return
        }),
    })
}

// there needs to be only one instance
export const utilities_btns = Widget.Window({
    name: WINDOW_NAME,
    class_name: "applauncher",
    setup: self => self.keybind("Escape", () => {
        App.closeWindow(WINDOW_NAME)
    }),
    visible: false,
    keymode: "exclusive",
    child: Btns({
        width: 300,
        height: 100,
        spacing: 12,
    }),
})
