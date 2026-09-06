import QtQuick 2.15

Column {
    id: root
    spacing: 8

    property color textColor: "#ffffff"
    property color accentColor: "#d9633b"
    property string timeFormat: "h:mm AP"
    property string dateFormat: "dddd, MMMM d, yyyy"

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: now = new Date()
    }
    property date now: new Date()

    Rectangle {
        width: 48
        height: 4
        radius: 2
        color: root.accentColor
    }

    Text {
        text: Qt.formatDateTime(root.now, root.timeFormat)
        color: root.textColor
        font.pixelSize: 56
        font.weight: Font.Bold
    }

    Text {
        text: Qt.formatDateTime(root.now, root.dateFormat)
        color: root.textColor
        opacity: 0.7
        font.pixelSize: 16
    }
}
