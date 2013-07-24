#!/bin/sh

echo "Usage: install_oracle_jdk.sh JDK_PACKAGE_FILE_NAME [JDK_VERSION]"
TEMP_DIR="/tmp/jdk"
INST_PACKAGE="$1"
JDK_VERSION="1.7"

if [ -n "$2" ]; then
    JDK_VERSION="$2"
    echo "You have specified a JDK version: [$JDK_VERSION]"
else
    echo "Default JDK version is 1.7"
fi

echo "Preparing and extracting package......"
sudo rm -rf $TEMP_DIR
mkdir -p $TEMP_DIR
tar zxf $INST_PACKAGE -C $TEMP_DIR

OUTPUT_DIR=`ls $TEMP_DIR`
VALID_JDK_DIR=`echo $OUTPUT_DIR | grep "jdk"`

if [ -z "$VALID_JDK_DIR" ]; then
    echo "There is no jdk folder found."
    exit 1
fi


JDK_SRC="$TEMP_DIR/$OUTPUT_DIR"
JDK_TARGET="/opt/$OUTPUT_DIR"
JDK_LINK="/opt/jdk${JDK_VERSION}"
echo "JDK package is extracted at: $JDK_SRC"

echo "Setup JDK environment......"
sudo chown -R root:root $JDK_SRC
sudo mv $JDK_SRC $JDK_TARGET
sudo ln -s $JDK_TARGET "$JDK_LINK"

echo "Update alternatives......"
sudo update-alternatives --install /usr/bin/java java $JDK_LINK/bin/java 10
sudo update-alternatives --set java $JDK_LINK/bin/java
sudo update-alternatives --install /usr/bin/jar jar $JDK_LINK/bin/jar 10
sudo update-alternatives --set jar $JDK_LINK/bin/jar
sudo update-alternatives --install /usr/bin/javac javac $JDK_LINK/bin/javac 10
sudo update-alternatives --set javac $JDK_LINK/bin/javac

echo "JDK package is installed."
