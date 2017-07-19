
// For compilers that support precompilation, includes "wx/wx.h".

#include <wxProzShow.h>
#include <wx/log.h>
#include <wx/msgout.h>
#include <wx/file.h>
#include <wx/filefn.h>
#include <wx/textfile.h>
#include <wx/debug.h>


/*
 * ProcHandler: Constructor
 */
ProcHandler::ProcHandler() : wxObject() {
	procDir = NULL;
}

/*
 * ProcHandler: Destructor
 */
ProcHandler::~ProcHandler() {

}

/*
 * ProcHandler::init(wxGrid *mGrid)
 * Parameter:	wxGrid *mGrid - wxGrid object, not tested for validity
 * Return bool: true==success, false==fail
 *
 * Description: Depending on the OS flag from the Makefile the OS dependent
 * 				process information gathering is done. The result is appended in
 * 				the wxGrid mGrid object.
 */
#ifndef __LINUX_DYNAMIC__
#include <windows.h>
#include <stdio.h>
#include <tchar.h>
#include <psapi.h>
#include <comdef.h>

#define wxDISABLE_ASSERTS_IN_RELEASE_BUILD() 	   wxDisableAsserts()
bool ProcHandler::init(wxGrid *mGrid) {

	DWORD aProcesses[1024], cbNeeded, cProcesses;
	unsigned int i;

	if ( !EnumProcesses( aProcesses, sizeof(aProcesses), &cbNeeded ) )
	{
		return false;
	}

	cProcesses = cbNeeded / sizeof(DWORD);

	for ( i = 0; i < cProcesses; i++ ) {
		if( aProcesses[i] != 0 ) {
			ProcInfo nProc;
			TCHAR szProcessName[MAX_PATH] = TEXT("<unknown>");

			HANDLE hProcess = OpenProcess( PROCESS_QUERY_INFORMATION |
										   PROCESS_VM_READ,
										   FALSE, aProcesses[i] );
			if ( hProcess ) {
				HMODULE hMod;
				DWORD cbNeeded;

				if ( EnumProcessModules( hProcess, &hMod, sizeof(hMod),&cbNeeded) ) {
					GetModuleBaseName( hProcess, hMod, szProcessName,
									   sizeof(szProcessName)/sizeof(TCHAR) );
				}
				nProc.setProcName(wxString(szProcessName));

				TCHAR sUserName[512];
				DWORD uNameSize = 512;
				GetUserName( sUserName , &uNameSize);
				nProc.setProcUser(wxString(sUserName));
			}

			mGrid->AppendRows();
			nProc.setProcNr(wxString::Format("%d", (int)aProcesses[i]));
			mGrid->SetCellValue( mGrid->GetRows()-1, 0, nProc.getProcNr());
			mGrid->SetCellValue( mGrid->GetRows()-1, 1, nProc.getProcName());
			mGrid->SetCellValue( mGrid->GetRows()-1, 2, nProc.getProcUser());
			procList.Append((wxObject*)&nProc);

			CloseHandle( hProcess );
		}
	}

	return true;
}

#else
#include <sys/types.h>
#include <pwd.h>

#define _PROC_PATH "/proc"

//wxBusyCursor
//#include <wx/platinfo.h>
bool ProcHandler::init(wxGrid *mGrid) {
	if (!procDir) {
		procDir = new wxDir(_PROC_PATH);
	}
	bool existProc = procDir->IsOpened() && procDir->HasSubDirs();
	if (existProc) {
		wxString subdir;
		for (bool cont = procDir->GetFirst(&subdir, wxString(), wxDIR_DIRS);cont;cont = procDir->GetNext(&subdir)) {

			unsigned long procNum=0;
			if (!subdir.ToULong(&procNum, 10)) { continue; }
			ProcInfo nProc;
			nProc.setProcNr(subdir);
			subdir.Prepend(wxString(_PROC_PATH)+wxString("/"));
			if (wxDir::Exists(subdir)) {
				wxStructStat buf;
				mGrid->AppendRows();
				if (wxStat(subdir, &buf)<0) {
					continue;
				}
				struct passwd *pw = getpwuid(buf.st_uid);
				if (!pw) {
					nProc.setProcUser(wxString::Format(wxT("%d"), (int)buf.st_uid));
				} else {
					nProc.setProcUser(wxString(pw->pw_name));
					pw = NULL;
				}

			 	wxFile commP;
			 	wxString sP(subdir+"/comm");
			 	//wxMessageOutputDebug().Output(" path: "+sP);
			 	commP.Open(sP,wxFile::read, wxPOSIX_USER_READ|wxPOSIX_GROUP_READ|wxPOSIX_OTHERS_READ);

			 	char buf_T[256]={0};
			 	commP.Read((void*)&buf_T, 256);
			 	commP.Close();
			 	nProc.setProcName(buf_T);

			 	mGrid->SetCellValue( mGrid->GetRows()-1, 0, nProc.getProcNr() );
			 	mGrid->SetCellValue( mGrid->GetRows()-1, 1, nProc.getProcName() );
			 	mGrid->SetCellValue( mGrid->GetRows()-1, 2, nProc.getProcUser() );

				procList.Append((wxObject*)&nProc);
			}
		}
	}
	if (procDir) {
		procDir->Close();
		delete procDir;
		procDir = NULL;
	}

	return existProc;
}

#endif


/*
 * ProcInfo:	Constructor
 *
 * Description: ProcInfo is the base information of the gathered Processes
 */
ProcInfo::ProcInfo() {
	procNr = "";
	procName = "";
	procUser = "";
}

ProcInfo::ProcInfo(wxString nprocNr,wxString nprocName,wxString nprocUser) {
	procNr = nprocNr;
	procName = nprocName;
	procUser = nprocUser;
}

ProcInfo::~ProcInfo() {

}

wxBEGIN_EVENT_TABLE(MyFrame, wxFrame)
    EVT_MENU(ID_Hello,   MyFrame::OnHello)
    EVT_MENU(wxID_EXIT,  MyFrame::OnExit)
    EVT_MENU(wxID_ABOUT, MyFrame::OnAbout)
    EVT_MENU(ID_Refresh, MyFrame::OnRefresh)
	EVT_SIZE( MyFrame::OnResize)
wxEND_EVENT_TABLE()
wxIMPLEMENT_APP(MyApp);

bool MyApp::OnInit()
{
    MyFrame *frame = new MyFrame( "Simple Process table", wxPoint(50, 50), wxSize(800, 600) );
    frame->Show( true );

    frame->initTable();
    return true;
}
MyFrame::MyFrame(const wxString& title, const wxPoint& pos, const wxSize& size)
        : wxFrame(NULL, wxID_ANY, title, pos)
{
	wxDISABLE_ASSERTS_IN_RELEASE_BUILD();
	pHandler = NULL;
    wxMenu *menuFile = new wxMenu;
    menuFile->Append(ID_Refresh, "&Refresh...\tCtrl-R", " Refresh page");
    menuFile->AppendSeparator();
    menuFile->Append(wxID_EXIT);
    wxMenu *menuHelp = new wxMenu;
    menuHelp->Append(wxID_ABOUT);
    wxMenuBar *menuBar = new wxMenuBar;
    menuBar->Append( menuFile, "&File" );
    menuBar->Append( menuHelp, "&Help" );
    mGrid = new wxGrid;

    SetMenuBar( menuBar );
    CreateStatusBar();
    SetStatusText( "Process by pID" );
}

MyFrame::~MyFrame() {
	delete pHandler;
	if (mGrid) {
		mGrid->ClearGrid();
		delete mGrid;
		mGrid = NULL;
	}
}

void MyFrame::initTable() {

	pHandler = new ProcHandler();

	mGrid->Create(this, this->GetId(), wxPoint(0,1), this->GetSize());
	mGrid->CreateGrid(0,3);
	mGrid->EnableEditing(false);

	mGrid->SetColLabelValue(0, wxString("pID"));
	mGrid->SetColLabelValue(1, wxString("Name"));
	mGrid->SetColLabelValue(2, wxString("User"));

	pHandler->init(mGrid);

	mGrid->AdjustScrollbars();
	wxSizeEvent initSize(this->GetSize());
	OnResize(initSize);
//	wxMessageOutputDebug().Output(" this->GetSize(): "+wxString::Format(wxT("%d"),this->GetSize().GetWidth()));

}

void MyFrame::OnExit(wxCommandEvent& event)
{
    Close( true );
}
void MyFrame::OnAbout(wxCommandEvent& event)
{
    wxMessageBox( "This is a simple process table by ID, Process name and User name ",
                  "About Process table", wxOK | wxICON_INFORMATION );
}
void MyFrame::OnHello(wxCommandEvent& event)
{
    wxLogMessage("Hello world from wxWidgets!");
}

void MyFrame::OnResize(wxSizeEvent& event)
{
    mGrid->SetSize(event.GetSize().GetWidth()-5, event.GetSize().GetHeight()-50);
    //smGrid->DoGetBestSize();
    int amount_cols = mGrid->GetCols();
    if (amount_cols<1) { amount_cols=1;}
    int nWidth = (event.GetSize().GetWidth()-100)/amount_cols;
    while (amount_cols>0) {
    	mGrid->SetColSize(amount_cols-1, nWidth);
    	amount_cols--;
    }
}

void MyFrame::OnRefresh(wxCommandEvent& event)
{
    wxLogMessage("Refresh the process list\n!");

}
