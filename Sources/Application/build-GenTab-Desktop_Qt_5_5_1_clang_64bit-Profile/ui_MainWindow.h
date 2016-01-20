/********************************************************************************
** Form generated from reading UI file 'MainWindow.ui'
**
** Created by: Qt User Interface Compiler version 5.5.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QButtonGroup>
#include <QtWidgets/QFormLayout>
#include <QtWidgets/QHBoxLayout>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QRadioButton>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QTextBrowser>
#include <QtWidgets/QTextEdit>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QWidget *centralWidget;
    QTextEdit *textEdit;
    QWidget *horizontalLayoutWidget_2;
    QHBoxLayout *horizontalLayout_2;
    QVBoxLayout *verticalLayout_4;
    QFormLayout *formLayout_3;
    QTextBrowser *textBrowser_2;
    QLineEdit *lineEdit_2;
    QVBoxLayout *verticalLayout_5;
    QPushButton *pushButton_8;
    QPushButton *pushButton_9;
    QWidget *horizontalLayoutWidget_3;
    QHBoxLayout *horizontalLayout_5;
    QVBoxLayout *verticalLayout_8;
    QFormLayout *formLayout_5;
    QTextBrowser *textBrowser_4;
    QLineEdit *lineEdit_4;
    QVBoxLayout *verticalLayout_9;
    QPushButton *pushButton_12;
    QPushButton *pushButton_13;
    QLabel *label_2;
    QLabel *label_4;
    QWidget *horizontalLayoutWidget_5;
    QHBoxLayout *horizontalLayout_7;
    QHBoxLayout *horizontalLayout_6;
    QTextBrowser *textBrowser_5;
    QVBoxLayout *verticalLayout_3;
    QRadioButton *radioButton_2;
    QRadioButton *radioButton;
    QLabel *label_3;
    QWidget *horizontalLayoutWidget_7;
    QHBoxLayout *horizontalLayout_9;
    QLabel *label_5;
    QVBoxLayout *verticalLayout;
    QTextBrowser *textBrowser_6;
    QHBoxLayout *horizontalLayout;
    QHBoxLayout *horizontalLayout_8;
    QLineEdit *lineEdit_5;
    QPushButton *pushButton_15;
    QPushButton *pushButton_14;
    QMenuBar *menuBar;
    QStatusBar *statusBar;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QStringLiteral("MainWindow"));
        MainWindow->setWindowModality(Qt::NonModal);
        MainWindow->setEnabled(true);
        MainWindow->resize(1280, 720);
        MainWindow->setAutoFillBackground(true);
        MainWindow->setStyleSheet(QStringLiteral("background: url(/Users/apple/Desktop/Gentab_projet/Sources/Application/GenTab/guitar.jpeg)"));
        centralWidget = new QWidget(MainWindow);
        centralWidget->setObjectName(QStringLiteral("centralWidget"));
        textEdit = new QTextEdit(centralWidget);
        textEdit->setObjectName(QStringLiteral("textEdit"));
        textEdit->setEnabled(false);
        textEdit->setGeometry(QRect(430, 0, 421, 51));
        textEdit->setAutoFillBackground(false);
        textEdit->setStyleSheet(QLatin1String("color: rgb(255, 17, 29);\n"
"font: 75 13pt \"Georgia\";\n"
"background-color: transparent;\n"
"\n"
""));
        textEdit->setOverwriteMode(true);
        horizontalLayoutWidget_2 = new QWidget(centralWidget);
        horizontalLayoutWidget_2->setObjectName(QStringLiteral("horizontalLayoutWidget_2"));
        horizontalLayoutWidget_2->setGeometry(QRect(170, 370, 451, 179));
        horizontalLayout_2 = new QHBoxLayout(horizontalLayoutWidget_2);
        horizontalLayout_2->setSpacing(6);
        horizontalLayout_2->setContentsMargins(11, 11, 11, 11);
        horizontalLayout_2->setObjectName(QStringLiteral("horizontalLayout_2"));
        horizontalLayout_2->setContentsMargins(0, 0, 0, 0);
        verticalLayout_4 = new QVBoxLayout();
        verticalLayout_4->setSpacing(6);
        verticalLayout_4->setObjectName(QStringLiteral("verticalLayout_4"));
        formLayout_3 = new QFormLayout();
        formLayout_3->setSpacing(6);
        formLayout_3->setObjectName(QStringLiteral("formLayout_3"));
        textBrowser_2 = new QTextBrowser(horizontalLayoutWidget_2);
        textBrowser_2->setObjectName(QStringLiteral("textBrowser_2"));

        formLayout_3->setWidget(0, QFormLayout::SpanningRole, textBrowser_2);


        verticalLayout_4->addLayout(formLayout_3);

        lineEdit_2 = new QLineEdit(horizontalLayoutWidget_2);
        lineEdit_2->setObjectName(QStringLiteral("lineEdit_2"));
        lineEdit_2->setStyleSheet(QLatin1String("color: rgb(186, 186, 186);\n"
"background-color:white;\n"
""));

        verticalLayout_4->addWidget(lineEdit_2);


        horizontalLayout_2->addLayout(verticalLayout_4);

        verticalLayout_5 = new QVBoxLayout();
        verticalLayout_5->setSpacing(6);
        verticalLayout_5->setObjectName(QStringLiteral("verticalLayout_5"));
        pushButton_8 = new QPushButton(horizontalLayoutWidget_2);
        pushButton_8->setObjectName(QStringLiteral("pushButton_8"));
        pushButton_8->setEnabled(true);
        pushButton_8->setAutoFillBackground(false);
        pushButton_8->setStyleSheet(QStringLiteral("color: rgb(186, 186, 186);"));

        verticalLayout_5->addWidget(pushButton_8);

        pushButton_9 = new QPushButton(horizontalLayoutWidget_2);
        pushButton_9->setObjectName(QStringLiteral("pushButton_9"));
        pushButton_9->setEnabled(true);
        pushButton_9->setAutoFillBackground(false);
        pushButton_9->setStyleSheet(QStringLiteral("color: rgb(186, 186, 186);"));

        verticalLayout_5->addWidget(pushButton_9);


        horizontalLayout_2->addLayout(verticalLayout_5);

        horizontalLayoutWidget_3 = new QWidget(centralWidget);
        horizontalLayoutWidget_3->setObjectName(QStringLiteral("horizontalLayoutWidget_3"));
        horizontalLayoutWidget_3->setGeometry(QRect(790, 370, 441, 91));
        horizontalLayout_5 = new QHBoxLayout(horizontalLayoutWidget_3);
        horizontalLayout_5->setSpacing(6);
        horizontalLayout_5->setContentsMargins(11, 11, 11, 11);
        horizontalLayout_5->setObjectName(QStringLiteral("horizontalLayout_5"));
        horizontalLayout_5->setContentsMargins(0, 0, 0, 0);
        verticalLayout_8 = new QVBoxLayout();
        verticalLayout_8->setSpacing(6);
        verticalLayout_8->setObjectName(QStringLiteral("verticalLayout_8"));
        formLayout_5 = new QFormLayout();
        formLayout_5->setSpacing(6);
        formLayout_5->setObjectName(QStringLiteral("formLayout_5"));
        textBrowser_4 = new QTextBrowser(horizontalLayoutWidget_3);
        textBrowser_4->setObjectName(QStringLiteral("textBrowser_4"));

        formLayout_5->setWidget(0, QFormLayout::SpanningRole, textBrowser_4);


        verticalLayout_8->addLayout(formLayout_5);

        lineEdit_4 = new QLineEdit(horizontalLayoutWidget_3);
        lineEdit_4->setObjectName(QStringLiteral("lineEdit_4"));
        lineEdit_4->setStyleSheet(QLatin1String("color: rgb(186, 186, 186);\n"
"background-color:white;\n"
""));

        verticalLayout_8->addWidget(lineEdit_4);


        horizontalLayout_5->addLayout(verticalLayout_8);

        verticalLayout_9 = new QVBoxLayout();
        verticalLayout_9->setSpacing(6);
        verticalLayout_9->setObjectName(QStringLiteral("verticalLayout_9"));
        pushButton_12 = new QPushButton(horizontalLayoutWidget_3);
        pushButton_12->setObjectName(QStringLiteral("pushButton_12"));
        pushButton_12->setEnabled(true);
        pushButton_12->setAutoFillBackground(false);
        pushButton_12->setStyleSheet(QStringLiteral("color: rgb(186, 186, 186);"));

        verticalLayout_9->addWidget(pushButton_12);

        pushButton_13 = new QPushButton(horizontalLayoutWidget_3);
        pushButton_13->setObjectName(QStringLiteral("pushButton_13"));
        pushButton_13->setEnabled(true);
        pushButton_13->setAutoFillBackground(false);
        pushButton_13->setStyleSheet(QStringLiteral("color: rgb(186, 186, 186);"));

        verticalLayout_9->addWidget(pushButton_13);


        horizontalLayout_5->addLayout(verticalLayout_9);

        label_2 = new QLabel(centralWidget);
        label_2->setObjectName(QStringLiteral("label_2"));
        label_2->setGeometry(QRect(40, 370, 101, 91));
        label_2->setPixmap(QPixmap(QString::fromUtf8("dos.png")));
        label_2->setScaledContents(true);
        label_4 = new QLabel(centralWidget);
        label_4->setObjectName(QStringLiteral("label_4"));
        label_4->setGeometry(QRect(680, 370, 101, 91));
        label_4->setPixmap(QPixmap(QString::fromUtf8("quatro.png")));
        label_4->setScaledContents(true);
        horizontalLayoutWidget_5 = new QWidget(centralWidget);
        horizontalLayoutWidget_5->setObjectName(QStringLiteral("horizontalLayoutWidget_5"));
        horizontalLayoutWidget_5->setGeometry(QRect(740, 150, 261, 82));
        horizontalLayout_7 = new QHBoxLayout(horizontalLayoutWidget_5);
        horizontalLayout_7->setSpacing(6);
        horizontalLayout_7->setContentsMargins(11, 11, 11, 11);
        horizontalLayout_7->setObjectName(QStringLiteral("horizontalLayout_7"));
        horizontalLayout_7->setContentsMargins(0, 0, 0, 0);
        horizontalLayout_6 = new QHBoxLayout();
        horizontalLayout_6->setSpacing(6);
        horizontalLayout_6->setObjectName(QStringLiteral("horizontalLayout_6"));
        textBrowser_5 = new QTextBrowser(horizontalLayoutWidget_5);
        textBrowser_5->setObjectName(QStringLiteral("textBrowser_5"));

        horizontalLayout_6->addWidget(textBrowser_5);

        verticalLayout_3 = new QVBoxLayout();
        verticalLayout_3->setSpacing(6);
        verticalLayout_3->setObjectName(QStringLiteral("verticalLayout_3"));
        radioButton_2 = new QRadioButton(horizontalLayoutWidget_5);
        radioButton_2->setObjectName(QStringLiteral("radioButton_2"));
        radioButton_2->setEnabled(true);
        radioButton_2->setStyleSheet(QStringLiteral("color: rgb(186, 186, 186);"));

        verticalLayout_3->addWidget(radioButton_2);

        radioButton = new QRadioButton(horizontalLayoutWidget_5);
        radioButton->setObjectName(QStringLiteral("radioButton"));
        radioButton->setEnabled(true);
        radioButton->setStyleSheet(QStringLiteral("color: rgb(186, 186, 186);"));

        verticalLayout_3->addWidget(radioButton);


        horizontalLayout_6->addLayout(verticalLayout_3);


        horizontalLayout_7->addLayout(horizontalLayout_6);

        label_3 = new QLabel(centralWidget);
        label_3->setObjectName(QStringLiteral("label_3"));
        label_3->setGeometry(QRect(630, 150, 89, 77));
        label_3->setPixmap(QPixmap(QString::fromUtf8("tres.png")));
        label_3->setScaledContents(true);
        horizontalLayoutWidget_7 = new QWidget(centralWidget);
        horizontalLayoutWidget_7->setObjectName(QStringLiteral("horizontalLayoutWidget_7"));
        horizontalLayoutWidget_7->setGeometry(QRect(60, 150, 541, 184));
        horizontalLayout_9 = new QHBoxLayout(horizontalLayoutWidget_7);
        horizontalLayout_9->setSpacing(6);
        horizontalLayout_9->setContentsMargins(11, 11, 11, 11);
        horizontalLayout_9->setObjectName(QStringLiteral("horizontalLayout_9"));
        horizontalLayout_9->setContentsMargins(0, 0, 0, 0);
        label_5 = new QLabel(horizontalLayoutWidget_7);
        label_5->setObjectName(QStringLiteral("label_5"));
        label_5->setPixmap(QPixmap(QString::fromUtf8("dos.png")));
        label_5->setScaledContents(true);

        horizontalLayout_9->addWidget(label_5);

        verticalLayout = new QVBoxLayout();
        verticalLayout->setSpacing(6);
        verticalLayout->setObjectName(QStringLiteral("verticalLayout"));
        textBrowser_6 = new QTextBrowser(horizontalLayoutWidget_7);
        textBrowser_6->setObjectName(QStringLiteral("textBrowser_6"));

        verticalLayout->addWidget(textBrowser_6);

        horizontalLayout = new QHBoxLayout();
        horizontalLayout->setSpacing(6);
        horizontalLayout->setObjectName(QStringLiteral("horizontalLayout"));
        horizontalLayout_8 = new QHBoxLayout();
        horizontalLayout_8->setSpacing(6);
        horizontalLayout_8->setObjectName(QStringLiteral("horizontalLayout_8"));
        lineEdit_5 = new QLineEdit(horizontalLayoutWidget_7);
        lineEdit_5->setObjectName(QStringLiteral("lineEdit_5"));
        lineEdit_5->setStyleSheet(QLatin1String("color: rgb(186, 186, 186);\n"
"background-color:white;\n"
""));

        horizontalLayout_8->addWidget(lineEdit_5);


        horizontalLayout->addLayout(horizontalLayout_8);

        pushButton_15 = new QPushButton(horizontalLayoutWidget_7);
        pushButton_15->setObjectName(QStringLiteral("pushButton_15"));
        pushButton_15->setEnabled(true);
        pushButton_15->setAutoFillBackground(false);
        pushButton_15->setStyleSheet(QStringLiteral("color: rgb(186, 186, 186);"));

        horizontalLayout->addWidget(pushButton_15);

        pushButton_14 = new QPushButton(horizontalLayoutWidget_7);
        pushButton_14->setObjectName(QStringLiteral("pushButton_14"));
        pushButton_14->setEnabled(true);
        pushButton_14->setAutoFillBackground(false);
        pushButton_14->setStyleSheet(QStringLiteral("color: rgb(186, 186, 186);"));

        horizontalLayout->addWidget(pushButton_14);


        verticalLayout->addLayout(horizontalLayout);


        horizontalLayout_9->addLayout(verticalLayout);

        MainWindow->setCentralWidget(centralWidget);
        textEdit->raise();
        horizontalLayoutWidget_2->raise();
        horizontalLayoutWidget_3->raise();
        label_2->raise();
        label_4->raise();
        horizontalLayoutWidget_5->raise();
        label_3->raise();
        horizontalLayoutWidget_7->raise();
        menuBar = new QMenuBar(MainWindow);
        menuBar->setObjectName(QStringLiteral("menuBar"));
        menuBar->setGeometry(QRect(0, 0, 1280, 22));
        MainWindow->setMenuBar(menuBar);
        statusBar = new QStatusBar(MainWindow);
        statusBar->setObjectName(QStringLiteral("statusBar"));
        MainWindow->setStatusBar(statusBar);

        retranslateUi(MainWindow);

        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QApplication::translate("MainWindow", "MainWindow", 0));
        textEdit->setHtml(QApplication::translate("MainWindow", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:'Georgia'; font-size:13pt; font-weight:72; font-style:normal;\">\n"
"<p style=\" margin-top:12px; margin-bottom:12px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:36pt; font-weight:600; color:#a71819;\">Bienvenue sur Gentab</span></p></body></html>", 0));
        textBrowser_2->setHtml(QApplication::translate("MainWindow", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:'.SF NS Text'; font-size:13pt; font-weight:400; font-style:normal;\">\n"
"<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:18pt; font-weight:600; color:#a8a8a8;\">Wave file</span></p></body></html>", 0));
        lineEdit_2->setText(QString());
        pushButton_8->setText(QApplication::translate("MainWindow", "Explore", 0));
        pushButton_9->setText(QApplication::translate("MainWindow", "Open", 0));
        textBrowser_4->setHtml(QApplication::translate("MainWindow", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:'.SF NS Text'; font-size:13pt; font-weight:400; font-style:normal;\">\n"
"<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:18pt; font-weight:600; color:#a8a8a8;\">Filename</span></p></body></html>", 0));
        lineEdit_4->setText(QString());
        pushButton_12->setText(QApplication::translate("MainWindow", "Explore", 0));
        pushButton_13->setText(QApplication::translate("MainWindow", "Open", 0));
        label_2->setText(QString());
        label_4->setText(QString());
        textBrowser_5->setHtml(QApplication::translate("MainWindow", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:'.SF NS Text'; font-size:13pt; font-weight:400; font-style:normal;\">\n"
"<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:14pt; font-weight:600; color:#a8a8a8;\">Export to</span></p></body></html>", 0));
        radioButton_2->setText(QApplication::translate("MainWindow", "     GP4", 0));
#ifndef QT_NO_TOOLTIP
        radioButton->setToolTip(QApplication::translate("MainWindow", "<html><head/><body><p><br/></p></body></html>", 0));
#endif // QT_NO_TOOLTIP
        radioButton->setText(QApplication::translate("MainWindow", "     MIDI", 0));
        label_3->setText(QString());
        label_5->setText(QString());
        textBrowser_6->setHtml(QApplication::translate("MainWindow", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:'.SF NS Text'; font-size:13pt; font-weight:400; font-style:normal;\">\n"
"<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:18pt; font-weight:600; color:#a8a8a8;\">Audacity project</span></p></body></html>", 0));
        lineEdit_5->setText(QString());
        pushButton_15->setText(QApplication::translate("MainWindow", "Explore", 0));
        pushButton_14->setText(QApplication::translate("MainWindow", "Open", 0));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
