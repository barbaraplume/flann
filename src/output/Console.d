/* 
Project: nn
*/

module output.Console;

import tango.io.Console;
import tango.core.Vararg;
import tango.text.convert.Layout;

import util.Logger;
import util.defines;


public ConsoleWriter console;

static this()
{
	console = new ConsoleWriter();
}

class ConsoleWriter {

	private Layout!(char) layout;
	
	alias write opCall;
	
	public this() 
	{
		layout = new Layout!(char);	
	}

	ConsoleWriter write(...)
	{
		char[] format = va_arg!(char[])(_argptr);
		layout((char[] s){return Cout.stream.write(s);},_arguments[1..$],_argptr,format);
		Cout.flush();
		
		return this;
	}
}





typedef void delegate() Ticker;

void showOperation(string message, void delegate() action)
{
	logger.info(message~"... ");
	action();
	logger.info("done");
}



void showProgressBar(int maxValue, int maxWidth, void delegate(Ticker ticker) action)
{
	int crtValue = 0;
	int crtWidth = 0;

	void tick()
	{
		if (crtValue<=maxValue) {
			crtValue++;
		}
		
		if (crtValue==maxValue) {
			console("\x08\x08\x08\x08\x08\x08=====]\n");
			crtValue++;
		}
		else if (crtValue<maxValue) {
			int newWidth = (crtValue*maxWidth)/maxValue;
			if (newWidth!=crtWidth) {
				
				int percent = (100*crtValue)/maxValue;
			
				console("\x08\x08\x08\x08\x08\x08=({:D2}%)>",percent);
				crtWidth++;
			}
		}
	}

	console("[      ");
	
	action(&tick);
}

void showProgressBarStep(int maxValue, int maxWidth, void delegate(int index) action)
{
	int crtValue = 0;
	int crtWidth = 0;

	void tick()
	{
		if (crtValue<=maxValue) {
			crtValue++;
		}
		
		if (crtValue==maxValue) {
			console("\x08\x08\x08\x08\x08\x08=====]\n");
			crtValue++;
		}
		else if (crtValue<maxValue) {
			int newWidth = (crtValue*maxWidth)/maxValue;
			if (newWidth!=crtWidth) {
				
				int percent = (100*crtValue)/maxValue;
			
				console("\x08\x08\x08\x08\x08\x08=({}%)>",percent);
				crtWidth++;
			}
		}
	}

	console("[      ");
	
	for (int index=0;index<maxValue;++index) {
		action(index);
		tick();
	}
}


/*
private class ProgressBar
{
	int crtValue;
	int maxValue;
	
	int maxWidth;
	int crtWidth;


	public this(int value, int width)
	{
		maxValue = value;
		maxWidth = width;
	}
	
	
	public:
	
	void start()
	{
		crtValue = 0;
		crtWidth = 0;
		
		Logger.log(Logger.INFO,"[      ");
	}
	
	void tick()
	{
		if (crtValue<=maxValue) {
			crtValue++;
		}
		
		if (crtValue==maxValue) {
			Logger.log(Logger.INFO,"\x08\x08\x08\x08\x08\x08=====]\n");
			crtValue++;
		}
		else if (crtValue<maxValue) {
			int newWidth = (crtValue*maxWidth)/maxValue;
			if (newWidth!=crtWidth) {
				
				int percent = (100*crtValue)/maxValue;
			
				Logger.log(Logger.INFO,"\x08\x08\x08\x08\x08\x08=(%2d%%)>",percent);
				crtWidth++;
			}
		}
	}

}
*/