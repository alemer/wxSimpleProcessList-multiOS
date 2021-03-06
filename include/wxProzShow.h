/* For compilers that support precompilation, includes "wx/wx.h".
 Created by alemer. See alemer.de for more information
 Released under MIT license.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE. 
*/


#include <wx/wxprec.h>
#include <wx/grid.h>
#include <wx/dir.h>
#ifndef WX_PRECOMP
    #include <wx/wx.h>
#endif

class ProcInfo
{
public:
	ProcInfo();
	ProcInfo(wxString nprocNr,wxString nprocName,wxString nprocUser);
	~ProcInfo();

	inline void setProcNr(wxString nprocNr) { procNr=nprocNr; }
	inline wxString getProcNr() { return procNr; }

	inline void setProcName(wxString nprocName) { procName=nprocName; }
	inline wxString getProcName() { return procName; }

	inline void setProcUser(wxString nprocUser) { procUser=nprocUser; }
	inline wxString getProcUser() { return procUser; }
private:
	wxString procNr;
	wxString procName;
	wxString procUser;

};

class ProcHandler : public wxObject
{
public:
	ProcHandler();
	~ProcHandler();
	bool init(wxGrid *mGrid);

private:
	wxDir *procDir;
	wxList procList;

};

class MyApp: public wxApp
{
public:
    virtual bool OnInit();
};
class MyFrame: public wxFrame
{
public:
    MyFrame(const wxString& title, const wxPoint& pos, const wxSize& size);
    ~MyFrame();
    void initTable();
private:
    ProcHandler *pHandler;
    wxGrid *mGrid;
    void OnHello(wxCommandEvent& event);
    void OnExit(wxCommandEvent& event);
    void OnAbout(wxCommandEvent& event);
    void OnRefresh(wxCommandEvent& event);
    void OnResize(wxSizeEvent& event);
    wxDECLARE_EVENT_TABLE();
};

enum
{
    ID_Hello = 1,
    ID_Refresh=0x00FA
};


