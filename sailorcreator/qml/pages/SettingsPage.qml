import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id:page
    property int gradient_color: 1
    property int gradient_color_: 1
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge
        VerticalScrollDecorator {}
        Column {
            id: column
            spacing: Theme.paddingMedium
            width: parent.width

            PageHeader {
                title: qsTr("Settings")
            }
            SectionHeader {
                text: qsTr("Appearance & Theme")
            }
            TextSwitch {
                text: qsTr("Line numbers")
                checked: lineNums
                onCheckedChanged: {
                    lineNums = checked
                }
            }
            Row{
                TextSwitch {
                    id:darkT
                    checked: darkTheme
                    text: qsTr("Dark Theme")
                    width: column.width/2 -Theme.paddingSmall
                    onCheckedChanged: {
                        console.log(checked)
                        darkTheme = checked
                        lightT.checked = !checked
                        if(darkTheme){
                            textColor="#cfbfad"
                            qmlHighlightColor="#ff8bff"
                            keywordsHighlightColor="#808bed"
                            propertiesHighlightColor="#ff5555"
                            javascriptHighlightColor="#8888ff"
                            stringHighlightColor="#ffcd8b"
                            commentHighlightColor="#cd8b00"
                            bgColor="#1e1e27"
                        }else{
                            textColor=Theme.highlightColor
                            qmlHighlightColor=Theme.highlightColor
                            keywordsHighlightColor=Theme.highlightDimmerColor
                            propertiesHighlightColor=Theme.primaryColor
                            javascriptHighlightColor=Theme.secondaryHighlightColor
                            stringHighlightColor=Theme.secondaryColor
                            commentHighlightColor= Theme.highlightBackgroundColor
                            bgColor="transparent"
                        }
                    }
                }
                TextSwitch {
                    id:lightT
                    checked: !darkTheme
                    text: qsTr("Ambience Theme")
                    width: column.width/2 -Theme.paddingSmall
                    onCheckedChanged: {
                         darkT.checked = !checked
                     }
                }

            }
            ComboBox {
                label: qsTr("Color of:")
                value: "Asd"

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("ExtraSmall")
                        onClicked:{

                        }
                    }
                    MenuItem {
                        text: qsTr("Small")
                        onClicked:{

                        }
                    }
                }
            }

            Slider {
                id: slider
                Rectangle {
                    id: background
                    x: slider.leftMargin
                    z: -1
                    width: slider._grooveWidth
                    height: Theme.paddingMedium
                    anchors.top: parent.verticalCenter
                    anchors.topMargin: -Theme.paddingLarge*2

                    ShaderEffect {
                        id: rainbow
                        property variant src: background
                        property real saturation: 1.0
                        property real lightness: 0.5
                        property real alpha: 1.0

                        width: parent.width
                        height: parent.height

                        // Fragment shader to create hue color wheel background
                        fragmentShader: "
                                        varying highp vec2 coord;
                                        varying highp vec2 qt_TexCoord0;
                                        uniform sampler2D src;
                                        uniform lowp float qt_Opacity;
                                        uniform lowp float saturation;
                                        uniform lowp float lightness;
                                        uniform lowp float alpha;

                                        void main() {
                                            float r, g, b;

                                            float h = qt_TexCoord0.x * 360.0;
                                            float s = saturation;
                                            float l = lightness;

                                            float c = (1.0 - abs(2.0 * l - 1.0)) * s;
                                            float hh = h / 60.0;
                                            float x = c * (1.0 - abs(mod(hh, 2.0) - 1.0));

                                            int i = int( hh );

                                            if (i == 0) {
                                                r = c; g = x; b = 0.0;
                                            } else if (i == 1) {
                                                r = x; g = c; b = 0.0;
                                            } else if (i == 2) {
                                                r = 0.0; g = c; b = x;
                                            } else if (i == 3) {
                                                r = 0.0; g = x; b = c;
                                            } else if (i == 4) {
                                                r = x; g = 0.0; b = c;
                                            } else if (i == 5) {
                                                r = c; g = 0.0; b = x;
                                            } else {
                                                r = 0.0; g = 0.0; b = 0.0;
                                            }

                                            float m = l - 0.5 * c;

                                            lowp vec4 tex = texture2D(src, qt_TexCoord0);
                                            gl_FragColor = vec4(r+m,g+m,b+m,alpha) * qt_Opacity;
                                        }"
                    }
                }

                width: parent.width
                minimumValue: 0
                maximumValue: 100
                stepSize: 1
                value: gradient_color
                valueText: "|"
                onValueChanged: {
                    gradient_color = value
                console.log(Qt.hsla((gradient_color/100),1.0,0.5,1.0))
                }
                onPressAndHold: cancel()

                Label {
                    width: parent.width
                    wrapMode: Text.Wrap
                    font.pixelSize: Theme.fontSizeSmall
                    horizontalAlignment: Text.AlignHCenter
                    anchors.top: parent.verticalCenter
                    anchors.topMargin: Theme.paddingMedium*2
                    color: Qt.hsla((gradient_color/100),1.0,0.5,1.0)
                    text: qsTr("Gradient color")

                    function toHsl(percentage){

                    }
                }
            }



            SectionHeader {
                text: qsTr("Automatic")
            }
            TextSwitch {
                text: qsTr("Auto saving")
                checked: autoSave
                onCheckedChanged: {
                    autoSave = checked
                }
            }
            Slider {
                label: qsTr("Indent size")
                width: parent.width
                value: indentSize
                minimumValue: 0
                valueText: (value==0) ? qsTr("Off") : value
                stepSize:1
                maximumValue: 8
                onReleased: {
                    indentSize = sliderValue
                }
            }

            SectionHeader {
                text: qsTr("Font")
            }
            ComboBox {
                label: qsTr("Font size:")
                value: fontSize

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("ExtraSmall")
                        onClicked:{
                            fontSize = Theme.fontSizeExtraSmall;
                        }
                    }
                    MenuItem {
                        text: qsTr("Small")
                        onClicked:{
                            fontSize = Theme.fontSizeSmall;
                        }
                    }
                    MenuItem {
                        text: qsTr("Medium")
                        onClicked:{
                            fontSize = Theme.fontSizeMedium;
                        }
                    }
                    MenuItem {
                        text:qsTr("Large")
                        onClicked:{
                            fontSize = Theme.fontSizeLarge;
                        }
                    }
                }
            }

            ComboBox {
                label: qsTr("Font:")
                value: fontType

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Sail Sans Pro Light")
                        onClicked:{
                            fontType = Theme.fontFamily;
                        }
                    }
                    MenuItem {
                        text: qsTr("Open Sans")
                        onClicked:{
                            fontType = "Open Sans";
                        }
                    }
                    MenuItem {
                        text:qsTr("Helvetica")
                        onClicked:{
                            fontType = "Helvetica";
                        }
                    }
                    MenuItem {
                        text: qsTr("Droid Sans Mono")
                        onClicked:{
                            fontType = "Droid Sans Mono";
                        }
                    }
                    MenuItem {
                        text: qsTr("Comic Sans")
                        onClicked:{
                            fontType = "Comic Sans";
                        }
                    }
                    MenuItem {
                        text: qsTr("Ubuntu")
                        onClicked:{
                            fontType = "Ubuntu";
                        }
                    }
                    MenuItem {
                        text: qsTr("DejaVu Sans Mono")
                        onClicked:{
                            fontType = "DejaVu Sans Mono";
                        }
                    }
                }
            }
            SectionHeader {
                text: qsTr("Debugging")
            }
            TextSwitch {
                text: qsTr("QML TRACE")
                checked: trace
                onCheckedChanged: {
                    trace = checked
                }
            }

        }


    }

}

