/********************************************************************************
** Form generated from reading UI file 'MainWindow.ui'
**
** Created by: Qt User Interface Compiler version 5.4.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QButtonGroup>
#include <QtWidgets/QCheckBox>
#include <QtWidgets/QGridLayout>
#include <QtWidgets/QGroupBox>
#include <QtWidgets/QHBoxLayout>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QRadioButton>
#include <QtWidgets/QSpacerItem>
#include <QtWidgets/QTextBrowser>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QWidget *centralWidget;
    QHBoxLayout *horizontalLayout_4;
    QSpacerItem *horizontalSpacer_10;
    QVBoxLayout *mainLayout;
    QSpacerItem *verticalSpacer_11;
    QTextBrowser *texteTitreLogiciel;
    QSpacerItem *verticalSpacer_12;
    QGridLayout *gridLayout;
    QHBoxLayout *horizontalLayout_10;
    QLabel *imageNum2;
    QGroupBox *groupBox;
    QVBoxLayout *verticalLayout_2;
    QSpacerItem *verticalSpacer_2;
    QTextBrowser *texteWaveFile;
    QHBoxLayout *horizontalLayout_2;
    QSpacerItem *horizontalSpacer_6;
    QLineEdit *waveFileLineEdit;
    QPushButton *pushButtonPlayWaveFile;
    QPushButton *pushButtonLoadWaveFile;
    QSpacerItem *verticalSpacer_16;
    QSpacerItem *verticalSpacer_8;
    QSpacerItem *verticalSpacer_7;
    QHBoxLayout *horizontalLayout_14;
    QLabel *imageNum3;
    QHBoxLayout *horizontalLayout_7;
    QGroupBox *groupBox1;
    QHBoxLayout *horizontalLayout_6;
    QTextBrowser *texteExportation;
    QVBoxLayout *verticalLayout_3;
    QRadioButton *buttonGP4;
    QRadioButton *buttonMIDI;
    QSpacerItem *horizontalSpacer_4;
    QGridLayout *gridLayout_2;
    QLineEdit *imposedTempoLineEdit;
    QLabel *foundTempoLabel;
    QLabel *imposedTempoLabel;
    QLineEdit *foundTempoLineEdit;
    QCheckBox *imposedTempoCheckBox;
    QSpacerItem *verticalSpacer_9;
    QSpacerItem *verticalSpacer_10;
    QHBoxLayout *horizontalLayout_3;
    QLabel *imageNum4;
    QHBoxLayout *horizontalLayout_12;
    QGroupBox *groupBox2;
    QVBoxLayout *verticalLayout_4;
    QSpacerItem *verticalSpacer_3;
    QTextBrowser *texteFilename;
    QHBoxLayout *horizontalLayout_5;
    QSpacerItem *horizontalSpacer;
    QLineEdit *filenameLineEdit;
    QPushButton *pushButtonExploreFilename;
    QPushButton *pushButtonSaveFilename;
    QSpacerItem *verticalSpacer_18;
    QSpacerItem *verticalSpacer_17;
    QHBoxLayout *horizontalLayout_9;
    QLabel *imageNum1;
    QGroupBox *groupBox3;
    QVBoxLayout *verticalLayout;
    QSpacerItem *verticalSpacer_14;
    QTextBrowser *texteAudacityProject;
    QHBoxLayout *horizontalLayout;
    QSpacerItem *horizontalSpacer_5;
    QLineEdit *audacityProjectLineEdit;
    QPushButton *pushButtonNewAudacityProject;
    QPushButton *pushButtonOpenAudacityProject;
    QPushButton *pushButtonExploreAudacityProject;
    QVBoxLayout *verticalLayout_7;
    QSpacerItem *verticalSpacer_15;
    QSpacerItem *verticalSpacer;
    QSpacerItem *verticalSpacer_6;
    QSpacerItem *verticalSpacer_5;
    QSpacerItem *verticalSpacer_4;
    QSpacerItem *verticalSpacer_13;
    QSpacerItem *horizontalSpacer_11;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QStringLiteral("MainWindow"));
        MainWindow->setWindowModality(Qt::ApplicationModal);
        MainWindow->setEnabled(true);
        MainWindow->resize(650, 734);
        MainWindow->setMinimumSize(QSize(650, 650));
        MainWindow->setAutoFillBackground(true);
        MainWindow->setStyleSheet(QLatin1String("#centralWidget{\n"
"background: url(:/guitar.jpeg);\n"
"background-position: center;\n"
"background-repeat: no-repeat;\n"
"}\n"
"\n"
"QGroupBox{\n"
"background-color:qlineargradient(x1:1 y1:0, x2:0 y2:0, stop:0 rgba(48, 48, 48, 0), stop:1 rgba(48, 48, 48, 200)); \n"
"border-top-left-radius: 6px;\n"
"border-bottom-left-radius: 6px;\n"
"}\n"
"\n"
"QTextBrowser{\n"
"	background-color: transparent;\n"
"}"));
        MainWindow->setAnimated(true);
        MainWindow->setDocumentMode(false);
        MainWindow->setUnifiedTitleAndToolBarOnMac(true);
        centralWidget = new QWidget(MainWindow);
        centralWidget->setObjectName(QStringLiteral("centralWidget"));
        centralWidget->setEnabled(true);
        horizontalLayout_4 = new QHBoxLayout(centralWidget);
        horizontalLayout_4->setSpacing(6);
        horizontalLayout_4->setContentsMargins(11, 11, 11, 11);
        horizontalLayout_4->setObjectName(QStringLiteral("horizontalLayout_4"));
        horizontalSpacer_10 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_4->addItem(horizontalSpacer_10);

        mainLayout = new QVBoxLayout();
        mainLayout->setSpacing(6);
        mainLayout->setObjectName(QStringLiteral("mainLayout"));
        verticalSpacer_11 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        mainLayout->addItem(verticalSpacer_11);

        texteTitreLogiciel = new QTextBrowser(centralWidget);
        texteTitreLogiciel->setObjectName(QStringLiteral("texteTitreLogiciel"));
        QSizePolicy sizePolicy(QSizePolicy::Expanding, QSizePolicy::Preferred);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(texteTitreLogiciel->sizePolicy().hasHeightForWidth());
        texteTitreLogiciel->setSizePolicy(sizePolicy);
        texteTitreLogiciel->setMaximumSize(QSize(16777215, 70));
        QFont font;
        font.setFamily(QStringLiteral("Letter Gothic Std"));
        font.setBold(true);
        font.setWeight(75);
        texteTitreLogiciel->setFont(font);
        texteTitreLogiciel->setStyleSheet(QStringLiteral("background-color:transparent;"));
        texteTitreLogiciel->setFrameShape(QFrame::NoFrame);
        texteTitreLogiciel->setHorizontalScrollBarPolicy(Qt::ScrollBarAsNeeded);

        mainLayout->addWidget(texteTitreLogiciel);

        verticalSpacer_12 = new QSpacerItem(20, 0, QSizePolicy::Minimum, QSizePolicy::Expanding);

        mainLayout->addItem(verticalSpacer_12);

        gridLayout = new QGridLayout();
        gridLayout->setSpacing(6);
        gridLayout->setObjectName(QStringLiteral("gridLayout"));
        horizontalLayout_10 = new QHBoxLayout();
        horizontalLayout_10->setSpacing(6);
        horizontalLayout_10->setObjectName(QStringLiteral("horizontalLayout_10"));
        imageNum2 = new QLabel(centralWidget);
        imageNum2->setObjectName(QStringLiteral("imageNum2"));
        QSizePolicy sizePolicy1(QSizePolicy::Minimum, QSizePolicy::Minimum);
        sizePolicy1.setHorizontalStretch(0);
        sizePolicy1.setVerticalStretch(0);
        sizePolicy1.setHeightForWidth(imageNum2->sizePolicy().hasHeightForWidth());
        imageNum2->setSizePolicy(sizePolicy1);
        imageNum2->setMinimumSize(QSize(128, 116));
        imageNum2->setStyleSheet(QLatin1String("background: url(:/dos_final.png);\n"
"background-repeat: no-repeat;\n"
""));

        horizontalLayout_10->addWidget(imageNum2);

        groupBox = new QGroupBox(centralWidget);
        groupBox->setObjectName(QStringLiteral("groupBox"));
        verticalLayout_2 = new QVBoxLayout(groupBox);
        verticalLayout_2->setSpacing(6);
        verticalLayout_2->setContentsMargins(11, 11, 11, 11);
        verticalLayout_2->setObjectName(QStringLiteral("verticalLayout_2"));
        verticalSpacer_2 = new QSpacerItem(20, 0, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout_2->addItem(verticalSpacer_2);

        texteWaveFile = new QTextBrowser(groupBox);
        texteWaveFile->setObjectName(QStringLiteral("texteWaveFile"));
        QSizePolicy sizePolicy2(QSizePolicy::Expanding, QSizePolicy::Fixed);
        sizePolicy2.setHorizontalStretch(0);
        sizePolicy2.setVerticalStretch(0);
        sizePolicy2.setHeightForWidth(texteWaveFile->sizePolicy().hasHeightForWidth());
        texteWaveFile->setSizePolicy(sizePolicy2);
        texteWaveFile->setMaximumSize(QSize(16777215, 60));
        texteWaveFile->setStyleSheet(QStringLiteral(""));
        texteWaveFile->setFrameShape(QFrame::NoFrame);
        texteWaveFile->setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);

        verticalLayout_2->addWidget(texteWaveFile);

        horizontalLayout_2 = new QHBoxLayout();
        horizontalLayout_2->setSpacing(6);
        horizontalLayout_2->setObjectName(QStringLiteral("horizontalLayout_2"));
        horizontalSpacer_6 = new QSpacerItem(40, 20, QSizePolicy::Fixed, QSizePolicy::Minimum);

        horizontalLayout_2->addItem(horizontalSpacer_6);

        waveFileLineEdit = new QLineEdit(groupBox);
        waveFileLineEdit->setObjectName(QStringLiteral("waveFileLineEdit"));
        waveFileLineEdit->setReadOnly(true);

        horizontalLayout_2->addWidget(waveFileLineEdit);

        pushButtonPlayWaveFile = new QPushButton(groupBox);
        pushButtonPlayWaveFile->setObjectName(QStringLiteral("pushButtonPlayWaveFile"));
        pushButtonPlayWaveFile->setEnabled(false);
        pushButtonPlayWaveFile->setAutoFillBackground(false);
        pushButtonPlayWaveFile->setStyleSheet(QStringLiteral(""));

        horizontalLayout_2->addWidget(pushButtonPlayWaveFile);

        pushButtonLoadWaveFile = new QPushButton(groupBox);
        pushButtonLoadWaveFile->setObjectName(QStringLiteral("pushButtonLoadWaveFile"));
        pushButtonLoadWaveFile->setEnabled(true);
        pushButtonLoadWaveFile->setAutoFillBackground(false);
        pushButtonLoadWaveFile->setStyleSheet(QStringLiteral(""));

        horizontalLayout_2->addWidget(pushButtonLoadWaveFile);


        verticalLayout_2->addLayout(horizontalLayout_2);

        verticalSpacer_16 = new QSpacerItem(20, 0, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout_2->addItem(verticalSpacer_16);


        horizontalLayout_10->addWidget(groupBox);


        gridLayout->addLayout(horizontalLayout_10, 3, 0, 1, 1);

        verticalSpacer_8 = new QSpacerItem(20, 0, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout->addItem(verticalSpacer_8, 5, 0, 1, 1);

        verticalSpacer_7 = new QSpacerItem(20, 0, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout->addItem(verticalSpacer_7, 4, 0, 1, 1);

        horizontalLayout_14 = new QHBoxLayout();
        horizontalLayout_14->setSpacing(6);
        horizontalLayout_14->setObjectName(QStringLiteral("horizontalLayout_14"));
        imageNum3 = new QLabel(centralWidget);
        imageNum3->setObjectName(QStringLiteral("imageNum3"));
        sizePolicy1.setHeightForWidth(imageNum3->sizePolicy().hasHeightForWidth());
        imageNum3->setSizePolicy(sizePolicy1);
        imageNum3->setMinimumSize(QSize(128, 116));
        imageNum3->setStyleSheet(QLatin1String("background: url(:/tres_final.png);\n"
"background-repeat: no-repeat;\n"
""));

        horizontalLayout_14->addWidget(imageNum3);

        horizontalLayout_7 = new QHBoxLayout();
        horizontalLayout_7->setSpacing(6);
        horizontalLayout_7->setObjectName(QStringLiteral("horizontalLayout_7"));
        groupBox1 = new QGroupBox(centralWidget);
        groupBox1->setObjectName(QStringLiteral("groupBox1"));
        horizontalLayout_6 = new QHBoxLayout(groupBox1);
        horizontalLayout_6->setSpacing(6);
        horizontalLayout_6->setContentsMargins(11, 11, 11, 11);
        horizontalLayout_6->setObjectName(QStringLiteral("horizontalLayout_6"));
        texteExportation = new QTextBrowser(groupBox1);
        texteExportation->setObjectName(QStringLiteral("texteExportation"));
        texteExportation->setMaximumSize(QSize(200, 100));
        texteExportation->setStyleSheet(QStringLiteral(""));
        texteExportation->setFrameShape(QFrame::NoFrame);

        horizontalLayout_6->addWidget(texteExportation);

        verticalLayout_3 = new QVBoxLayout();
        verticalLayout_3->setSpacing(6);
        verticalLayout_3->setObjectName(QStringLiteral("verticalLayout_3"));
        buttonGP4 = new QRadioButton(groupBox1);
        buttonGP4->setObjectName(QStringLiteral("buttonGP4"));
        buttonGP4->setEnabled(true);
        buttonGP4->setStyleSheet(QStringLiteral("color: rgb(186, 186, 186);"));

        verticalLayout_3->addWidget(buttonGP4);

        buttonMIDI = new QRadioButton(groupBox1);
        buttonMIDI->setObjectName(QStringLiteral("buttonMIDI"));
        buttonMIDI->setEnabled(true);
        buttonMIDI->setStyleSheet(QStringLiteral("color: rgb(186, 186, 186);"));
        buttonMIDI->setChecked(true);

        verticalLayout_3->addWidget(buttonMIDI);


        horizontalLayout_6->addLayout(verticalLayout_3);

        horizontalSpacer_4 = new QSpacerItem(100, 20, QSizePolicy::Fixed, QSizePolicy::Minimum);

        horizontalLayout_6->addItem(horizontalSpacer_4);

        gridLayout_2 = new QGridLayout();
        gridLayout_2->setSpacing(6);
        gridLayout_2->setObjectName(QStringLiteral("gridLayout_2"));
        imposedTempoLineEdit = new QLineEdit(groupBox1);
        imposedTempoLineEdit->setObjectName(QStringLiteral("imposedTempoLineEdit"));
        imposedTempoLineEdit->setInputMask(QStringLiteral(""));
        imposedTempoLineEdit->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);
        imposedTempoLineEdit->setPlaceholderText(QStringLiteral(""));

        gridLayout_2->addWidget(imposedTempoLineEdit, 0, 1, 1, 1);

        foundTempoLabel = new QLabel(groupBox1);
        foundTempoLabel->setObjectName(QStringLiteral("foundTempoLabel"));
        QPalette palette;
        QBrush brush(QColor(240, 240, 240, 255));
        brush.setStyle(Qt::SolidPattern);
        palette.setBrush(QPalette::Active, QPalette::WindowText, brush);
        palette.setBrush(QPalette::Inactive, QPalette::WindowText, brush);
        QBrush brush1(QColor(120, 120, 120, 255));
        brush1.setStyle(Qt::SolidPattern);
        palette.setBrush(QPalette::Disabled, QPalette::WindowText, brush1);
        foundTempoLabel->setPalette(palette);

        gridLayout_2->addWidget(foundTempoLabel, 1, 0, 1, 1);

        imposedTempoLabel = new QLabel(groupBox1);
        imposedTempoLabel->setObjectName(QStringLiteral("imposedTempoLabel"));
        QPalette palette1;
        palette1.setBrush(QPalette::Active, QPalette::WindowText, brush);
        palette1.setBrush(QPalette::Inactive, QPalette::WindowText, brush);
        palette1.setBrush(QPalette::Disabled, QPalette::WindowText, brush1);
        imposedTempoLabel->setPalette(palette1);

        gridLayout_2->addWidget(imposedTempoLabel, 0, 0, 1, 1);

        foundTempoLineEdit = new QLineEdit(groupBox1);
        foundTempoLineEdit->setObjectName(QStringLiteral("foundTempoLineEdit"));
        foundTempoLineEdit->setReadOnly(true);

        gridLayout_2->addWidget(foundTempoLineEdit, 1, 1, 1, 1);

        imposedTempoCheckBox = new QCheckBox(groupBox1);
        imposedTempoCheckBox->setObjectName(QStringLiteral("imposedTempoCheckBox"));

        gridLayout_2->addWidget(imposedTempoCheckBox, 0, 2, 1, 1);


        horizontalLayout_6->addLayout(gridLayout_2);


        horizontalLayout_7->addWidget(groupBox1);


        horizontalLayout_14->addLayout(horizontalLayout_7);


        gridLayout->addLayout(horizontalLayout_14, 6, 0, 1, 1);

        verticalSpacer_9 = new QSpacerItem(20, 0, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout->addItem(verticalSpacer_9, 7, 0, 1, 1);

        verticalSpacer_10 = new QSpacerItem(20, 0, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout->addItem(verticalSpacer_10, 12, 0, 1, 1);

        horizontalLayout_3 = new QHBoxLayout();
        horizontalLayout_3->setSpacing(6);
        horizontalLayout_3->setObjectName(QStringLiteral("horizontalLayout_3"));
        imageNum4 = new QLabel(centralWidget);
        imageNum4->setObjectName(QStringLiteral("imageNum4"));
        sizePolicy1.setHeightForWidth(imageNum4->sizePolicy().hasHeightForWidth());
        imageNum4->setSizePolicy(sizePolicy1);
        imageNum4->setMinimumSize(QSize(128, 116));
        imageNum4->setStyleSheet(QLatin1String("background: url(:/quatro_final.png);\n"
"background-repeat: no-repeat;"));

        horizontalLayout_3->addWidget(imageNum4);

        horizontalLayout_12 = new QHBoxLayout();
        horizontalLayout_12->setSpacing(6);
        horizontalLayout_12->setObjectName(QStringLiteral("horizontalLayout_12"));
        groupBox2 = new QGroupBox(centralWidget);
        groupBox2->setObjectName(QStringLiteral("groupBox2"));
        verticalLayout_4 = new QVBoxLayout(groupBox2);
        verticalLayout_4->setSpacing(6);
        verticalLayout_4->setContentsMargins(11, 11, 11, 11);
        verticalLayout_4->setObjectName(QStringLiteral("verticalLayout_4"));
        verticalSpacer_3 = new QSpacerItem(20, 0, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout_4->addItem(verticalSpacer_3);

        texteFilename = new QTextBrowser(groupBox2);
        texteFilename->setObjectName(QStringLiteral("texteFilename"));
        texteFilename->setEnabled(true);
        QSizePolicy sizePolicy3(QSizePolicy::Expanding, QSizePolicy::Minimum);
        sizePolicy3.setHorizontalStretch(0);
        sizePolicy3.setVerticalStretch(0);
        sizePolicy3.setHeightForWidth(texteFilename->sizePolicy().hasHeightForWidth());
        texteFilename->setSizePolicy(sizePolicy3);
        texteFilename->setMaximumSize(QSize(16777215, 60));
        texteFilename->setStyleSheet(QStringLiteral(""));
        texteFilename->setFrameShape(QFrame::NoFrame);

        verticalLayout_4->addWidget(texteFilename);

        horizontalLayout_5 = new QHBoxLayout();
        horizontalLayout_5->setSpacing(6);
        horizontalLayout_5->setObjectName(QStringLiteral("horizontalLayout_5"));
        horizontalSpacer = new QSpacerItem(40, 20, QSizePolicy::Fixed, QSizePolicy::Minimum);

        horizontalLayout_5->addItem(horizontalSpacer);

        filenameLineEdit = new QLineEdit(groupBox2);
        filenameLineEdit->setObjectName(QStringLiteral("filenameLineEdit"));
        filenameLineEdit->setInputMask(QStringLiteral(""));
        filenameLineEdit->setDragEnabled(true);
        filenameLineEdit->setClearButtonEnabled(false);

        horizontalLayout_5->addWidget(filenameLineEdit);

        pushButtonExploreFilename = new QPushButton(groupBox2);
        pushButtonExploreFilename->setObjectName(QStringLiteral("pushButtonExploreFilename"));
        pushButtonExploreFilename->setEnabled(true);
        pushButtonExploreFilename->setAutoFillBackground(false);
        pushButtonExploreFilename->setStyleSheet(QStringLiteral(""));

        horizontalLayout_5->addWidget(pushButtonExploreFilename);

        pushButtonSaveFilename = new QPushButton(groupBox2);
        pushButtonSaveFilename->setObjectName(QStringLiteral("pushButtonSaveFilename"));
        pushButtonSaveFilename->setEnabled(false);
        pushButtonSaveFilename->setAutoFillBackground(false);
        pushButtonSaveFilename->setStyleSheet(QStringLiteral(""));

        horizontalLayout_5->addWidget(pushButtonSaveFilename);


        verticalLayout_4->addLayout(horizontalLayout_5);

        verticalSpacer_18 = new QSpacerItem(20, 0, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout_4->addItem(verticalSpacer_18);

        verticalSpacer_17 = new QSpacerItem(20, 0, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout_4->addItem(verticalSpacer_17);


        horizontalLayout_12->addWidget(groupBox2);


        horizontalLayout_3->addLayout(horizontalLayout_12);


        gridLayout->addLayout(horizontalLayout_3, 10, 0, 1, 1);

        horizontalLayout_9 = new QHBoxLayout();
        horizontalLayout_9->setSpacing(6);
        horizontalLayout_9->setObjectName(QStringLiteral("horizontalLayout_9"));
        imageNum1 = new QLabel(centralWidget);
        imageNum1->setObjectName(QStringLiteral("imageNum1"));
        sizePolicy1.setHeightForWidth(imageNum1->sizePolicy().hasHeightForWidth());
        imageNum1->setSizePolicy(sizePolicy1);
        imageNum1->setMinimumSize(QSize(128, 124));
        imageNum1->setStyleSheet(QLatin1String("background:url(:/uno_final.png);\n"
"background-opacity: 0.6;\n"
"background-repeat: no-repeat;"));
        imageNum1->setScaledContents(true);

        horizontalLayout_9->addWidget(imageNum1);

        groupBox3 = new QGroupBox(centralWidget);
        groupBox3->setObjectName(QStringLiteral("groupBox3"));
        verticalLayout = new QVBoxLayout(groupBox3);
        verticalLayout->setSpacing(6);
        verticalLayout->setContentsMargins(11, 11, 11, 11);
        verticalLayout->setObjectName(QStringLiteral("verticalLayout"));
        verticalSpacer_14 = new QSpacerItem(20, 0, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout->addItem(verticalSpacer_14);

        texteAudacityProject = new QTextBrowser(groupBox3);
        texteAudacityProject->setObjectName(QStringLiteral("texteAudacityProject"));
        sizePolicy.setHeightForWidth(texteAudacityProject->sizePolicy().hasHeightForWidth());
        texteAudacityProject->setSizePolicy(sizePolicy);
        texteAudacityProject->setMaximumSize(QSize(16777215, 60));
        texteAudacityProject->setStyleSheet(QStringLiteral(""));
        texteAudacityProject->setFrameShape(QFrame::NoFrame);
        texteAudacityProject->setLineWidth(0);

        verticalLayout->addWidget(texteAudacityProject);

        horizontalLayout = new QHBoxLayout();
        horizontalLayout->setSpacing(6);
        horizontalLayout->setObjectName(QStringLiteral("horizontalLayout"));
        horizontalSpacer_5 = new QSpacerItem(40, 20, QSizePolicy::Fixed, QSizePolicy::Minimum);

        horizontalLayout->addItem(horizontalSpacer_5);

        audacityProjectLineEdit = new QLineEdit(groupBox3);
        audacityProjectLineEdit->setObjectName(QStringLiteral("audacityProjectLineEdit"));
        audacityProjectLineEdit->setReadOnly(true);

        horizontalLayout->addWidget(audacityProjectLineEdit);

        pushButtonNewAudacityProject = new QPushButton(groupBox3);
        pushButtonNewAudacityProject->setObjectName(QStringLiteral("pushButtonNewAudacityProject"));
        pushButtonNewAudacityProject->setEnabled(true);
        pushButtonNewAudacityProject->setAutoFillBackground(false);
        pushButtonNewAudacityProject->setStyleSheet(QStringLiteral(""));

        horizontalLayout->addWidget(pushButtonNewAudacityProject);

        pushButtonOpenAudacityProject = new QPushButton(groupBox3);
        pushButtonOpenAudacityProject->setObjectName(QStringLiteral("pushButtonOpenAudacityProject"));
        pushButtonOpenAudacityProject->setEnabled(false);
        pushButtonOpenAudacityProject->setAutoFillBackground(false);
        pushButtonOpenAudacityProject->setStyleSheet(QStringLiteral(""));

        horizontalLayout->addWidget(pushButtonOpenAudacityProject);

        pushButtonExploreAudacityProject = new QPushButton(groupBox3);
        pushButtonExploreAudacityProject->setObjectName(QStringLiteral("pushButtonExploreAudacityProject"));

        horizontalLayout->addWidget(pushButtonExploreAudacityProject);


        verticalLayout->addLayout(horizontalLayout);

        verticalLayout_7 = new QVBoxLayout();
        verticalLayout_7->setSpacing(6);
        verticalLayout_7->setObjectName(QStringLiteral("verticalLayout_7"));

        verticalLayout->addLayout(verticalLayout_7);

        verticalSpacer_15 = new QSpacerItem(20, 0, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout->addItem(verticalSpacer_15);


        horizontalLayout_9->addWidget(groupBox3);


        gridLayout->addLayout(horizontalLayout_9, 0, 0, 1, 1);

        verticalSpacer = new QSpacerItem(20, 0, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout->addItem(verticalSpacer, 9, 0, 1, 1);

        verticalSpacer_6 = new QSpacerItem(20, 0, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout->addItem(verticalSpacer_6, 2, 0, 1, 1);

        verticalSpacer_5 = new QSpacerItem(20, 0, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout->addItem(verticalSpacer_5, 8, 0, 1, 1);

        verticalSpacer_4 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout->addItem(verticalSpacer_4, 11, 0, 1, 1);

        verticalSpacer_13 = new QSpacerItem(20, 0, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout->addItem(verticalSpacer_13, 1, 0, 1, 1);


        mainLayout->addLayout(gridLayout);


        horizontalLayout_4->addLayout(mainLayout);

        horizontalSpacer_11 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_4->addItem(horizontalSpacer_11);

        MainWindow->setCentralWidget(centralWidget);

        retranslateUi(MainWindow);

        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QApplication::translate("MainWindow", "The GenTab Project", 0));
        texteTitreLogiciel->setHtml(QApplication::translate("MainWindow", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:'Letter Gothic Std'; font-size:8.25pt; font-weight:600; font-style:normal;\">\n"
"<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'.SF NS Text'; font-size:36pt; font-style:italic; color:#919191;\">Welcome to Gentab</span></p></body></html>", 0));
        imageNum2->setText(QString());
        texteWaveFile->setHtml(QApplication::translate("MainWindow", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:'MS Shell Dlg 2'; font-size:8.25pt; font-weight:400; font-style:normal;\">\n"
"<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'.SF NS Text'; font-size:14pt; font-weight:600; text-decoration: underline; color:#a8a8a8;\">Wave file</span></p>\n"
"<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'.SF NS Text'; font-size:10pt; color:#fcfcfc;\">You can play your recorded audio file if you want to..</span></p>\n"
"<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'"
                        ".SF NS Text'; font-size:10pt; color:#fcfcfc;\">Please select the audio file you want to convert by clicking on &quot;Load&quot;.</span></p></body></html>", 0));
        pushButtonPlayWaveFile->setText(QApplication::translate("MainWindow", "Play", 0));
        pushButtonLoadWaveFile->setText(QApplication::translate("MainWindow", "Load", 0));
        imageNum3->setText(QString());
        texteExportation->setHtml(QApplication::translate("MainWindow", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:'MS Shell Dlg 2'; font-size:8.25pt; font-weight:400; font-style:normal;\">\n"
"<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'.SF NS Text'; font-size:14pt; font-weight:600; text-decoration: underline; color:#a8a8a8;\">Export to</span></p></body></html>", 0));
        buttonGP4->setText(QApplication::translate("MainWindow", "     GP4", 0));
#ifndef QT_NO_TOOLTIP
        buttonMIDI->setToolTip(QApplication::translate("MainWindow", "<html><head/><body><p><br/></p></body></html>", 0));
#endif // QT_NO_TOOLTIP
        buttonMIDI->setText(QApplication::translate("MainWindow", "     MIDI", 0));
        foundTempoLabel->setText(QApplication::translate("MainWindow", "Found Tempo:", 0));
        imposedTempoLabel->setText(QApplication::translate("MainWindow", "Imposed Tempo:", 0));
        imposedTempoCheckBox->setText(QString());
        imageNum4->setText(QString());
        texteFilename->setHtml(QApplication::translate("MainWindow", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:'MS Shell Dlg 2'; font-size:8.25pt; font-weight:400; font-style:normal;\">\n"
"<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'.SF NS Text'; font-size:14pt; font-weight:600; text-decoration: underline; color:#a8a8a8;\">Filename</span></p>\n"
"<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'.SF NS Text'; font-size:14pt; color:#f5f5f5;\">Please name the file you want to save</span></p></body></html>", 0));
        pushButtonExploreFilename->setText(QApplication::translate("MainWindow", "...", 0));
        pushButtonSaveFilename->setText(QApplication::translate("MainWindow", "Save", 0));
        imageNum1->setText(QString());
        texteAudacityProject->setHtml(QApplication::translate("MainWindow", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:'MS Shell Dlg 2'; font-size:8.25pt; font-weight:400; font-style:normal;\">\n"
"<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'.SF NS Text'; font-size:14pt; font-weight:600; text-decoration: underline; color:#a8a8a8;\">Audacity project</span></p>\n"
"<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'.SF NS Text'; font-size:13pt; color:#ffffff;\">Please create or open an audacity project.</span></p></body></html>", 0));
        pushButtonNewAudacityProject->setText(QApplication::translate("MainWindow", "New", 0));
        pushButtonOpenAudacityProject->setText(QApplication::translate("MainWindow", "Open", 0));
        pushButtonExploreAudacityProject->setText(QApplication::translate("MainWindow", "Explore", 0));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
