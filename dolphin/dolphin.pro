TEMPLATE = aux

OTHER_FILES = *.qml \
*.png

qml.files = $${OTHER_FILES}
qml.path = /usr/share/maliit/plugins/com/jolla/sailorcreator/

INSTALLS += qml
