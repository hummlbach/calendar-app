import QtQuick 2.0
import Ubuntu.Components 0.1

Item{
    id: infoBubble

    property var event;

    property int type: narrowType
    property int wideType: 1;
    property int narrowType: 2;

    property Flickable flickable;

    readonly property int minimumHeight: timeLabel.height + /*top-bottom margin*/ units.gu(2)

    signal clicked(var event);

    UbuntuShape{
        id: bg
        anchors.fill: parent
        color: "white"
        gradientColor: "#F5F5F5"
    }

    onEventChanged: {
        setDetails();
    }

    //on weekview flickable changes, so we need to setup connection on flickble change
    onFlickableChanged: {
        if( flickable && height > flickable.height ) {
            flickable.onContentYChanged.connect(layoutBubbleDetails);
        }
    }

    //on dayview, flickable never changed so when height changes we setup connection
    onHeightChanged: {
        if( flickable && height > flickable.height ) {
            flickable.onContentYChanged.connect(layoutBubbleDetails);
        }
    }

    Component.onCompleted: {
        setDetails();
    }

    function setDetails() {
        if(event === null || event === undefined) {
            return;
        }

        // TRANSLATORS: this is a time formatting string,
        // see http://qt-project.org/doc/qt-5/qml-qtqml-date.html#details for valid expressions
        var timeFormat = i18n.tr("hh:mm");
        var startTime = event.startDateTime.toLocaleTimeString(Qt.locale(), timeFormat)
        var endTime = event.endDateTime.toLocaleTimeString(Qt.locale(), timeFormat)
        // TRANSLATORS: the first argument (%1) refers to a start time for an event,
        // while the second one (%2) refers to the end time
        var timeString = i18n.tr("%1 - %2").arg(startTime).arg(endTime)

        timeLabel.text = ""
        titleLabel.text = ""
        descriptionLabel.text = ""

        //height is less then set only event title
        if( height > minimumHeight ) {
            //on wide type show all details
            if( type == wideType) {
                timeLabel.text = timeString

                if( event.displayLabel)
                    titleLabel.text = event.displayLabel;
                if( event.description)
                {
                    descriptionLabel.text = event.description
                    //If content is too much don't display.
                    if( height < descriptionLabel.height + descriptionLabel.y){
                        descriptionLabel.text = ""
                    }
                }
            } else {
                //narrow type shows only time and title
                timeLabel.text = startTime

                if( event.displayLabel)
                    titleLabel.text = event.displayLabel;
            }
        } else {
            if( event.displayLabel)
                timeLabel.text = event.displayLabel;
        }

        layoutBubbleDetails();
    }

    function layoutBubbleDetails() {
        if( !flickable || flickable === undefined ) {
            return;
        }

        if( infoBubble.y < flickable.contentY && infoBubble.height > flickable.height) {
            var y = (flickable.contentY - infoBubble.y) * 1.2;
            if( ( y + detailsItems.height + units.gu(2)) > infoBubble.height) {
                y = infoBubble.height - detailsItems.height - units.gu(2);
            }
            detailsItems.y = y;
        }
    }

    Connections{
        target: detailsItems
        onHeightChanged: {
            layoutBubbleDetails();
        }
    }

    Item {
        id: detailsItems

        width: parent.width
        height: detailsColumn.height

        Column{
            id: detailsColumn

            anchors {
                top: parent.top; left: parent.left; right: parent.right; margins: units.gu(1)
            }

            Row{
                width: parent.width

                Label{
                    id: timeLabel
                    fontSize:"small";
                    color:"gray"
                    width: parent.width - rect.width
                }
                Rectangle{
                    id:rect
                    width: units.gu(1)
                    radius: width/2
                    height: width
                    color: "#715772"
                }
            }
            Label{
                id: titleLabel
                fontSize:"small";
                color:"black"
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                width: parent.width
            }

            Label{
                id: descriptionLabel
                fontSize:"small";
                color:"gray"
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                width: parent.width
                visible: type == wideType
            }
        }
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            infoBubble.clicked(event);
        }
    }
}
