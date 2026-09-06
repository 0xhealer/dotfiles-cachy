import QtQuick 2.15
import "components"

Rectangle {
    id: root
    width: Screen.width
    height: Screen.height
    color: config.backgroundColor

    // Subtle radial glow behind the panel - warm rust-orange, dim,
    // centered - the "glow border" characteristic in a general sense,
    // not sampled from any specific theme's actual asset.
    Rectangle {
        width: parent.width * 1.4
        height: parent.height * 1.4
        anchors.centerIn: parent
        radius: width / 2
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0.85, 0.39, 0.23, 0.10) }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    Rectangle {
        id: panel
        width: 720
        height: 420
        anchors.centerIn: parent
        radius: 28
        color: config.panelColor
        border.color: Qt.rgba(0.85, 0.39, 0.23, 0.35)
        border.width: 1

        layer.enabled: true

        Row {
            anchors.fill: parent
            anchors.margins: 48
            spacing: 48

            ClockWidget {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.45
                textColor: config.textColor
                accentColor: config.accentColor
                timeFormat: config.timeFormat
                dateFormat: config.dateFormat
            }

            Rectangle {
                width: 1
                height: parent.height * 0.7
                anchors.verticalCenter: parent.verticalCenter
                color: Qt.rgba(1, 1, 1, 0.08)
            }

            LoginPanel {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.45
                textColor: config.textColor
                textDimColor: config.textDimColor
                accentColor: config.accentColor

                onLoginRequested: function(user, password, session) {
                    sddm.login(user, password, session)
                }
            }
        }
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            // handled inside LoginPanel via its own error state
        }
    }
}
