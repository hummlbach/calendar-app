import QtQuick 2.0
import Ubuntu.Components 0.1

import "dateExt.js" as DateExt

UbuntuShape {
    id: root

    property var weekStart: DateExt.today();

    color: "#e6e4e9"

    TimeLineHeader{
        id: header
        type: typeWeek
        anchors.top: parent.top
    }

    Flickable{
        id: timeLineView

        anchors.top: header.bottom
        width: parent.width
        height: parent.height - header.height

        contentHeight: units.gu(10) * 24
        contentWidth: width

        clip: true

        TimeLineBackground{
        }

        Row{
            id: week
            width: parent.width
            height: parent.height
            anchors.top: parent.top

            Repeater{
                model: 7

                delegate: TimeLineBase {
                    anchors.top: parent.top
                    width: parent.width/7
                    height: parent.height
                    delegate: comp
                    day: weekStart.addDays(index)
                }
            }
        }
    }

    Component{
        id: comp
        EventBubble{
            type: narrowType
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: units.gu(0.1)
            anchors.rightMargin: units.gu(0.1)
        }
    }
}
