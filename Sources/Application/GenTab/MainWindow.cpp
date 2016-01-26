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

    connect(ui->pushButtonOpenAudacityProject,SIGNAL(clicked()), this, SLOT(openAudacity()));
    connect(ui->pushButtonExploreAudacityProject,SIGNAL(clicked()), this, SLOT(selectPath()));
    connect(ui->pushButtonSaveFilename, SIGNAL(clicked()), this, SLOT(onGenerateFileClicked()));
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::openAudacity()
{
   // Ouverture du fichier tampon
    QTextEdit * zoneTexte=new QTextEdit;
    ui->verticalLayout_5->addWidget(zoneTexte);
    
    zoneTexte->setGeometry(100,100,400,200);
    zoneTexte->setReadOnly(true);
    zoneTexte->setTextColor(Qt::blue);
    
    QString texte;
    QFile fichier("/Users/apple/Desktop/projetTampon.aup");
    
    if(fichier.open(QIODevice::ReadOnly))
       {
           texte="Le fichier tampon a bien été ouvert!";
           fichier.close();
       }
       else texte="Impossible d'ouvrir le fichier!";
       
    
    zoneTexte->setText(texte);
    zoneTexte->show();
    
    // Copie du chemin du nouveau projet
    
    if(!QFile::exists("chemin du fichier avec l'extension"))
        QMessageBox::critical(NULL,"Erreur","Ce fichier existe déjà.");
    
    
    //QFile fichier("tampon.txt");
    
    
    //QDesktopServices::openUrl(QUrl::fromLocalFile("/Applications/Audacity/Audacity.app"));
    
}

void MainWindow::selectPath()
{
    QTextEdit * zoneTexte=new QTextEdit;
    ui->verticalLayout_5->addWidget(zoneTexte);
    
    zoneTexte->setGeometry(100,100,400,200);
    zoneTexte->setReadOnly(true);
    zoneTexte->setTextColor(Qt::blue);
    
    QString texte;
    QFile fichier("/Users/apple/Desktop/projetTampon.aup");
    QString path=QFileDialog::getSaveFileName(this,"Enregistrer sous...",QDir::currentPath(),"Audacity project(*.aup)"); // path est le nom du chemin du nouveau fichier Audacity
    
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

    QFile::copy("/Users/apple/Desktop/projetTampon.aup",path); // copie le fichier tampon dans le repertoire path
    //Qstring result=path+name
    QFileInfo fich(path);
    QString nomRepertoire=fich.canonicalPath();
    
    zoneTexte->setText(nomRepertoire);
    zoneTexte->show();
    
    QFileInfo fi(path);
    QString nomUtilisateur=fi.baseName(); // le nom donné par l'utilisateur au projet audacity
    QString nomDossier=nomUtilisateur+"_data"; // le nom que doit avoir le dossier data pour pouvoir ouvrir le projet
    QString pathnomDossier=nomRepertoire+"/"+nomDossier;
    QDir().mkdir(pathnomDossier); // créer le dossier data
    

    
    QDesktopServices::openUrl(QUrl::fromLocalFile(path)); // ouvre le fichier audacity
    
   
}

void MainWindow::onGenerateFileClicked()
{
    _param.setAudioFileName(ui->waveFileLineEdit->text());
    _param.setExportFileName(ui->filenameLineEdit->text());
    Format format;
    if(ui->buttonGP4->isChecked())
        format = GP4;
    else
        format = MIDI;
    _param.runGentabScript(format);
}
