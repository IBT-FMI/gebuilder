/*
 * unbenannt.d
 * 
 * Copyright 2018 Unknown <dominik@X200>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 * 
 * 
 */


import std.stdio;
import std.process;
import std.range;
import std.experimental.logger;
import std.algorithm;
import std.file;

auto progList(string dir){
	string[] paths;
	progList(dir, paths);
	return paths;
}
bool attrIsExecutable(uint attributes) @safe pure nothrow @nogc {
	version(Windows) {
		static assert("Not implemented");
	}
	else version(Posix) {
		import core.sys.posix.sys.stat;
		return (attributes & (S_IXUSR | S_IXGRP | S_IXOTH)) > 0;
	}
}

void progList(string dir,ref string[] paths){
	auto ents=dirEntries(dir,SpanMode.shallow, true).array;
	ents.sort();
	foreach(e;ents){
		if(e.attributes.attrIsFile){
			if(e.attributes.attrIsExecutable){
				paths~=e.name;
			}
		}
		else if(e.attributes.attrIsDir){
			progList(e.name, paths);
		}
		else{
			warning("Unhandled dirent ",e);
		}
	}
}

struct Bash{
	import std.container.slist;
	private ProcessPipes pp;
	struct Source{
		void[] curbuf;
		void[] delegate() provider;
	}
	SList!(Source) buffers;
	
	void start(){
		pp=pipeProcess("/bin/cat",Redirect.all,["test":"asfd"]);
	}
	
	void send(in void[] buf){
		pp.stdin.rawWrite(buf);
	}
	
	void load(in string file){
		send(file.read);
	}
	
	void flush(){
		pp.stdin.flush();
	}
	
	T[] read(T)(T[] buf){
		return pp.stdout.rawRead(buf);
	}
	
	auto readAll(T)(){
		static T[2048] buf;
		return generate!(()=>read(buf)).until!(a=>a.empty).joiner();
	}
	
	int term(){
		pp.stdin.close();
		return wait(pp.pid);
	}
}

int main(string[] args){
	Bash b;
	b.start();
	auto list=progList(args[1]);
	char[2048] buf;
	foreach(p; list){
		b.load(p);
		writeln(b.read(buf));
	}
	writeln(b.term());
	return 0;
}

