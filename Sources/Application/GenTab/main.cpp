#include "MainWindow.h"
#include <QApplication>

#include "Parameters.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    Parameters* param = new Parameters();
    return a.exec();
}
