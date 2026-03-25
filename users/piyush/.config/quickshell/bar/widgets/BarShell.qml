import QtQuick
import "../theme"

Item {
    id: root

    default property alias contentData: content.data
    implicitHeight: Theme.shellHeight

    Item {
        id: content
        anchors.fill: parent
    }
}
