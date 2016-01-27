#include "MainWindow.h"
#include "ui_MainWindow.h"
#include <QCoreApplication>
#include <QDesktopServices>
#include <QFile>
#include <QString>
#include <QTextEdit>
#include <QGridLayout>
#include <QBoxLayout>
#include <QTabWidget>
#include <QTextStream>
#include <QFileDialog>
#include <QMessageBox>
#include <QFileInfo>
#include <QDir>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow),
    _param(Parameters())
{
    ui->setupUi(this);
    this->setWindowIcon(QIcon(":/Guitar-icon.png"));
    this->statusBar()->hide();
    this->menuBar()->hide();
    connect(ui->pushButtonOpenAudacityProject,SIGNAL(clicked()), this, SLOT(openAudacity()));
    connect(ui->pushButtonNewAudacityProject,SIGNAL(clicked()), this, SLOT(newAudacityProject()));
    connect(ui->pushButtonExploreAudacityProject,SIGNAL(clicked()), this, SLOT(exploreAudacity()));
    connect(ui->audacityProjectLineEdit, SIGNAL(textChanged(QString)), this, SLOT(onAudacityProjectTextChanged(QString)));

    connect(ui->pushButtonExploreWaveFile, SIGNAL(clicked()), this, SLOT(onExploreWave()));

    connect(ui->pushButtonSaveFilename, SIGNAL(clicked()), this, SLOT(onGenerateFileClicked()));
    connect(ui->filenameLineEdit, SIGNAL(textChanged(QString)), this, SLOT(onFileNameChanged(QString)));
    connect(ui->pushButtonExploreFilename, SIGNAL(clicked()), this, SLOT(onExploreFileName()));
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::openAudacity()
{
    if(this->ui->audacityProjectLineEdit->text().isEmpty() || !QFile::exists(this->ui->audacityProjectLineEdit->text()))
    {
        return;
    }

    QDesktopServices::openUrl(QUrl::fromLocalFile(this->ui->audacityProjectLineEdit->text()));// ouvre le fichier audacity
}

void MainWindow::newAudacityProject()
{
//    QTextEdit * zoneTexte=new QTextEdit;
//    ui->verticalLayout_5->addWidget(zoneTexte);
    
//    zoneTexte->setGeometry(100,100,400,200);
//    zoneTexte->setReadOnly(true);
//    zoneTexte->setTextColor(Qt::blue);
    
    QString texte;
    QString originalFile=_param._qsGentabPath + QDir::separator() + "projetTampon.aup";
    QFile fichier(originalFile);
    QString path=QFileDialog::getSaveFileName(this,"Enregistrer sous...",_param._qsAudacityProjectsPath,"Audacity project(*.aup)"); // path est le nom du chemin du nouveau fichier Audacity

    if(fichier.open(QIODevice::ReadOnly))
    {
        texte=path;
        fichier.close();
    }
    //zoneTexte->setText(texte);
    //zoneTexte->show(); // affiche le path
    
    QFileInfo fileInfo(path);
    QString name=fileInfo.fileName();
    
    //zoneTexte->setText(name);
    //zoneTexte->show();

    QFile::copy(originalFile,path); // copie le fichier tampon dans le repertoire path
    //Qstring result=path+name
    QFileInfo fich(path);
    QString nomRepertoire=fich.canonicalPath();
    
//    zoneTexte->setText(nomRepertoire);
//    zoneTexte->show();
    
    QFileInfo fi(path);
    QString nomUtilisateur=fich.baseName(); // le nom donné par l'utilisateur au projet audacity
    QString nomDossier=nomUtilisateur+"_data"; // le nom que doit avoir le dossier data pour pouvoir ouvrir le projet
    QString pathnomDossier=nomRepertoire+"/"+nomDossier;
    QDir().mkdir(pathnomDossier); // créer le dossier data
    
    this->ui->audacityProjectLineEdit->setText(path);
    
    QDesktopServices::openUrl(QUrl::fromLocalFile(path)); // ouvre le fichier audacity
    
   
}

void MainWindow::onGenerateFileClicked()
{
    _param.setAudioFileName(ui->waveFileLineEdit->text());
    _param.setExportFileName(ui->filenameLineEdit->text());

    QString extension;
    if(getFormat() == GP4)
        extension = ".gp4";
    else
        extension = ".mid";

    QFileInfo fichierPropose(_param._qsExportFileName + extension);
    bool warning =false;
    if(fichierPropose.exists())
    {
        warning = true;
    }else{
        QFile fichierRecompose(_param._qsGeneratedTabsPath + '/' + _param._qsExportFileName + extension);
        if(fichierRecompose.exists())
            warning = true;
        fichierPropose = fichierRecompose;
    }

    if(warning)
    {
        QMessageBox msgBox;
        msgBox.setText("This file already exists.");
        msgBox.setInformativeText("Do you want to erase it");
        msgBox.setStandardButtons(QMessageBox::Cancel | QMessageBox::Ok);
        msgBox.setDefaultButton(QMessageBox::Ok);
        int result = msgBox.exec();
        if(result == QMessageBox::Cancel)
            return;
    }

    if(_param.runGentabScript(getFormat()))
    {
        QMessageBox msgBox;
        msgBox.setText("The generation is complete");
        msgBox.setInformativeText("Do you want to open the ne file.");
        msgBox.setStandardButtons(QMessageBox::Open | QMessageBox::Close);
        msgBox.setDefaultButton(QMessageBox::Open);
        int result = msgBox.exec();
        if(result == QMessageBox::Open)
            QDesktopServices::openUrl(QUrl::fromLocalFile(fichierPropose.absoluteFilePath()));
    }
}

void MainWindow::onAudacityProjectTextChanged(QString newText)
{
    QFile fichier(newText);
    if(fichier.exists() && newText.endsWith(".aup"))
        this->ui->pushButtonOpenAudacityProject->setEnabled(true);
    else
        this->ui->pushButtonOpenAudacityProject->setDisabled(true);
}

void MainWindow::onExploreWave()
{
    QString path=QFileDialog::getOpenFileName(this,"Open...",_param._qsRecordedAudioFilesPath,"WAV File(*.wav)");
    if(!path.isEmpty() && path.endsWith(".wav"))
    {
        this->ui->waveFileLineEdit->setText(path);
        this->ui->pushButtonOpenWaveFile->setEnabled(true);
        if(!this->ui->filenameLineEdit->text().isEmpty())
            this->ui->pushButtonSaveFilename->setEnabled(true);
        else
            this->ui->pushButtonSaveFilename->setEnabled(false);
    }
}

void MainWindow::onFileNameChanged(QString qsNewFileName)
{
    QStringList qslTemp=qsNewFileName.split('.');
    qsNewFileName=qslTemp.at(0);

    if(!qsNewFileName.isEmpty())
    {
        this->ui->filenameLineEdit->setText(qsNewFileName);
        if(!this->ui->waveFileLineEdit->text().isEmpty())
            this->ui->pushButtonSaveFilename->setEnabled(true);
    }else{
        this->ui->filenameLineEdit->setText(qsNewFileName);
        this->ui->pushButtonSaveFilename->setEnabled(false);
    }
}

void MainWindow::exploreAudacity()
{
    QString path=QFileDialog::getOpenFileName(this,"Open...",_param._qsAudacityProjectsPath,"Audacity project(*.aup)"); // path est le nom du chemin du nouveau fichier Audacity
    if(!path.isEmpty() && path.endsWith(".aup"))
        this->ui->audacityProjectLineEdit->setText(path);
}

void MainWindow::onExploreFileName()
{
    QString path=QFileDialog::getOpenFileName(this,"Open...",_param._qsGeneratedTabsPath,"Partition(*.gp4 *.mid)");
    if(!path.isEmpty() && (path.endsWith(".gp4") || path.endsWith(".mid")))
    {
        QStringList qslTemp=path.split('.');
        path=qslTemp.at(0);
        QString extension = qslTemp.at(1);
        setFormat(extension);
        this->ui->filenameLineEdit->setText(path);
    }
}

Format MainWindow::getFormat()
{
    Format format;
    if(ui->buttonGP4->isChecked())
        format = GP4;
    else
        format = MIDI;
    return format;
}

void MainWindow::setFormat(QString extension)
{
    if(extension=="gp4")
        this->ui->buttonGP4->setChecked(true);
    else
        this->ui->buttonMIDI->setChecked(true);
}
