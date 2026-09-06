import QtQuick 2.15
import QtQuick.Controls 2.15

Column {
    id: root
    spacing: 16

    property color textColor: "#ffffff"
    property color textDimColor: "#a89a92"
    property color accentColor: "#d9633b"
    property string errorText: ""

    signal loginRequested(string user, string password, int session)

    Timer {
        id: errorTimer
        interval: 4000
        onTriggered: root.errorText = ""
    }

    Text {
        text: userModel.lastUser.length > 0 ? userModel.lastUser : qsTr("User")
        color: root.textColor
        font.pixelSize: 22
        font.weight: Font.DemiBold
    }

    Text {
        text: root.errorText
        color: root.accentColor
        visible: root.errorText.length > 0
        font.pixelSize: 13
    }

    Row {
        spacing: 10

        TextField {
            id: passwordField
            width: 220
            placeholderText: qsTr("Password")
            echoMode: TextInput.Password
            color: root.textColor
            placeholderTextColor: root.textDimColor
            background: Rectangle {
                radius: 8
                color: Qt.rgba(1, 1, 1, 0.06)
                border.color: Qt.rgba(1, 1, 1, 0.12)
                border.width: 1
            }
            onAccepted: submitButton.clicked()
            Component.onCompleted: forceActiveFocus()
        }

        Button {
            id: submitButton
            text: "\u2192"
            onClicked: {
                var sessionIndex = sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0
                root.loginRequested(userModel.lastUser, passwordField.text, sessionIndex)
                passwordField.text = ""
            }
            background: Rectangle {
                radius: 8
                color: root.accentColor
                implicitWidth: 40
                implicitHeight: passwordField.height
            }
            contentItem: Text {
                text: submitButton.text
                color: "#1a1720"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.weight: Font.Bold
            }
        }
    }

    Row {
        spacing: 24
        topPadding: 8

        Text {
            text: qsTr("Restart")
            color: root.textDimColor
            font.pixelSize: 13
            visible: sddm.canReboot
            MouseArea { anchors.fill: parent; onClicked: sddm.reboot() }
        }

        Text {
            text: qsTr("Shut Down")
            color: root.textDimColor
            font.pixelSize: 13
            visible: sddm.canPowerOff
            MouseArea { anchors.fill: parent; onClicked: sddm.powerOff() }
        }
    }
}
