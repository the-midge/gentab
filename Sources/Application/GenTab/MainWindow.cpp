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
#include <QDebug>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow),
    _param(Parameters()),
    _fileWatcher(this),
    _progressBar(this)

{
    ui->setupUi(this);
    _progressBar.setRange(0, 6);
    _progressBar.setValue(0);
    _progressBar.setTextVisible(false);
    _progressBar.show();
    this->setWindowIcon(QIcon(":/Guitar-icon.png"));
    connect(ui->pushButtonOpenAudacityProject,SIGNAL(clicked()), this, SLOT(openAudacity()));
    connect(ui->pushButtonNewAudacityProject,SIGNAL(clicked()), this, SLOT(newAudacityProject()));
    connect(ui->pushButtonExploreAudacityProject,SIGNAL(clicked()), this, SLOT(exploreAudacity()));

    connect(ui->pushButtonSaveFilename, SIGNAL(clicked()), this, SLOT(onGenerateFileClicked()));
    connect(ui->audacityProjectLineEdit, SIGNAL(textChanged(QString)), this, SLOT(onAudacityProjectTextChanged(QString)));
    connect(ui->waveFileLineEdit, SIGNAL(textChanged(QString)), this, SLOT(onWaveFileTextChanged(QString)));
    connect(ui->pushButtonPlayWaveFile,SIGNAL(clicked()), this, SLOT(playWave()));
    connect(ui->pushButtonLoadWaveFile,SIGNAL(clicked()), this, SLOT(loadWave()));
    connect(ui->filenameLineEdit, SIGNAL(textChanged(QString)), this, SLOT(onFileNameChanged(QString)));
    connect(ui->pushButtonExploreFilename, SIGNAL(clicked()), this, SLOT(onExploreFileName()));

    connect(&_fileWatcher, SIGNAL(fileChanged(QString)), this, SLOT(onLogFileChanged(QString)));
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

    QString texte;
    QString originalFile=_param._qsGentabPath + QDir::separator() + "projetTampon.aup";
    QFile fichier(originalFile);
    QString path=QFileDialog::getSaveFileName(this,"Enregistrer sous...",_param._qsAudacityProjectsPath,"Audacity project(*.aup)"); // path est le nom du chemin du nouveau fichier Audacity




    QFileInfo fileInfo(path);
    QString name=fileInfo.fileName();



    QFile::copy(originalFile,path); // copie le fichier tampon dans le repertoire path
    //Qstring result=path+name
    QFileInfo fich(path);
    QString nomRepertoire=fich.canonicalPath();


    QFileInfo fi(path);
    QString nomUtilisateur=fich.baseName(); // le nom donné par l'utilisateur au projet audacity
    QString nomDossier=nomUtilisateur+"_data"; // le nom que doit avoir le dossier data pour pouvoir ouvrir le projet
    QString pathnomDossier=nomRepertoire+"/"+nomDossier;
    QDir().mkdir(pathnomDossier); // créer le dossier data

    this->ui->audacityProjectLineEdit->setText(path);

    QDesktopServices::openUrl(QUrl::fromLocalFile(path)); // ouvre le fichier audacity


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


void MainWindow::onGenerateFileClicked()
{
    _param.setAudioFileName(ui->waveFileLineEdit->text());
    QFileInfo exportFile(ui->filenameLineEdit->text());
    _param.setExportFileName(exportFile.fileName());

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

    QString fichierLogPath = fichierPropose.absoluteFilePath().remove(extension) + ".log";
    QFile fichierLog(fichierLogPath);
    fichierLog.open(QIODevice::ReadWrite);
    _fileWatcher.addPath(fichierLogPath);

    _param.runGentabScript(getFormat());
    this->ui->mainLayout->addWidget(&_progressBar);
}

void MainWindow::onAudacityProjectTextChanged(QString newText)
{
    QFile fichier(newText);
    if(fichier.exists() && newText.endsWith(".aup"))
        this->ui->pushButtonOpenAudacityProject->setEnabled(true);
    else
        this->ui->pushButtonOpenAudacityProject->setDisabled(true);
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

void MainWindow::playWave()
{
    QDesktopServices::openUrl(QUrl::fromLocalFile(ui->waveFileLineEdit->text()));


}



void MainWindow::onWaveFileTextChanged(QString newText)
{
    QFile fichier(newText);
    if(fichier.exists() && newText.endsWith(".wav"))
        this->ui->pushButtonPlayWaveFile->setEnabled(true);
    else
        this->ui->pushButtonPlayWaveFile->setDisabled(true);
}

void MainWindow::loadWave()
{
    QString fileName2=QFileDialog::getOpenFileName(this,tr("Open File"),_param._qsRecordedAudioFilesPath,tr("Fichier Wave (*.wav *.wave)"));
    if(!fileName2.isEmpty() && fileName2.endsWith(".wav"))
        this->ui->waveFileLineEdit->setText(fileName2);
}

void MainWindow::onLogFileChanged(QString logFile)
{
    QFile file(logFile);
    file.open(QIODevice::ReadOnly | QIODevice::Text);
    QString line;
    int i=0;
    while(!file.atEnd()){
        line = file.readLine();
        i++;
    }
    switch(i)
    {
    case 0:
        qDebug() << "Initialisation, le script n'a pas commencé";
        break;
    case 1:
        qDebug() << line;
        break;
    case 2:
        qDebug() << line;
        break;
    case 3:
        qDebug() << line;
        break;
    case 4:
        qDebug() << line;
        break;
    case 5:
        qDebug() << line;
        break;
    case 6:
    {
        qDebug() << line;
        _progressBar.setValue(i);
        _fileWatcher.removePath(logFile);
        file.remove();
        QMessageBox msgBox;
        msgBox.setText("Generation succedeed.");
        msgBox.setInformativeText("Do you want to open the new file");
        msgBox.setStandardButtons(QMessageBox::Cancel | QMessageBox::Ok);
        msgBox.setDefaultButton(QMessageBox::Ok);
        int result = msgBox.exec();
        if(result == QMessageBox::Ok)
            QDesktopServices::openUrl(QUrl::fromLocalFile(_param._qsGeneratedTabsPath + "/" + _param._qsExportFileName + ".mid"));
    }
        break;
    default:
        break;
    }
    _progressBar.setValue(i);

    // line = last line
}
