function []=WriteX3DOM(NODE,FACE,filename,color,scale)

if nargin<3, error('Not enough input arguments.');
elseif nargin==3, color = 0.5*[1 1 1]; scale = 1;
elseif nargin==4, scale = 1;
end
if isempty(color), color=0.5*[1 1 1]; end

LIM = scale*[min(NODE); max(NODE)];
FACE = FACE-1;

stream = fopen(filename,'w');
WritePreamble(stream,filename);
WriteViewpoints(stream,LIM);

% Shape output
fprintf(stream,'      <transform scale="%g %g %g">\n',scale*[1 1 1]);
fprintf(stream,'        <shape>\n');
fprintf(stream,'          <appearance>\n');
fprintf(stream,'            <material diffuseColor="%.4f %.4f %.4f"/>\n',color);
fprintf(stream,'          </appearance>\n');
% Face output
for i=1:size(FACE,1)
    if i==1
        fprintf(stream,'          <indexedFaceSet solid="true" creaseAngle="3.141593" coordIndex="');
        fprintf(stream,'%g %g %g -1 ',FACE(i,:));
    elseif i==size(FACE,1)
        fprintf(stream,'%g %g %g -1">\n',FACE(i,:));
    else
        fprintf(stream,'%g %g %g -1 ',FACE(i,:));
    end
end
% Node output
for i=1:size(NODE,1)
    if i==1
        fprintf(stream,'            <coordinate point="');
        fprintf(stream,'%g %g %g ',NODE(i,:));
    elseif i==size(NODE,1)
        fprintf(stream,'%g %g %g"/>\n',NODE(i,:));
    else
        fprintf(stream,'%g %g %g ',NODE(i,:));
    end
end
fprintf(stream,'          </indexedFaceSet>\n');
fprintf(stream,'        </shape>\n');
fprintf(stream,'      </transform>\n');

WritePostscript(stream);
fclose(stream);

function []=WritePreamble(stream,filename)
fprintf(stream,'<html>\n');
fprintf(stream,'  <head>\n');
fprintf(stream,'    <title>3D Topology --- exported from TOPslicer</title>\n');
fprintf(stream,'    <meta content="%s" name="title"/>\n',filename);
fprintf(stream,'    <meta content="3D Topology --- exported from TOPslicer" name="description"/>\n');
fprintf(stream,'    <meta content="Tomas Zegard" name="creator"/>\n');
fprintf(stream,'    <meta content="%s" name="created"/>\n',date);
fprintf(stream,'    <link rel="stylesheet" type="text/css" href="http://www.x3dom.org/download/x3dom.css"/>\n');
fprintf(stream,'    <script type="text/javascript" src="http://www.x3dom.org/download/x3dom.js"/></script>\n');
fprintf(stream,'  </head>\n');
fprintf(stream,'  <body>\n');
fprintf(stream,'    <h1>3D Topology --- exported from TOPslicer</h1>\n');
fprintf(stream,'    <h2>author: Tomas Zegard</h2>\n');
fprintf(stream,'    <p>\n');
fprintf(stream,'      [E] Normal Rotation --- [G] Camera Rotation --- [F] Fly mode<br/>\n');
fprintf(stream,'      [PgUp] / [PgDn] Change view --- [R] Reset current view --- [SPACE] Stats on/off\n');
fprintf(stream,'    </p>\n');
fprintf(stream,'    <x3d id="boxes" showStat="true" showLog="false" x="0px" y="0px" width="800px" height="600px">\n');
fprintf(stream,'    <scene>\n');
return

function []=WritePostscript(stream)
fprintf(stream,'    </scene>\n');
fprintf(stream,'    </x3d>\n');
fprintf(stream,'  </body>\n');
fprintf(stream,'</html>\n');
return

function []=WriteViewpoints(stream,LIM)
center = mean(LIM); dim = max(diff(LIM));
fprintf(stream,'      <viewpoint description="ISO" position="%f %f %f" orientation="1.5 0.25 1 1" centerOfRotation="%f %f %f"></viewpoint>\n',max(dim)/2+center(1),-max(dim)+center(2),max(dim)+center(3),center);
fprintf(stream,'      <viewpoint description="TOP" position="%f %f %f" centerOfRotation="%f %f %f"></viewpoint>\n',center(1),center(2),1.25*max(dim)+center(3),center);
fprintf(stream,'      <viewpoint description="FRONT" position="%f %f %f" orientation="1 0 0 -1.5708" centerOfRotation="%f %f %f"></viewpoint>\n',center(1),1.25*max(dim)+center(2),center(3),center);
fprintf(stream,'      <viewpoint description="SIDE" position="%f %f %f" orientation="1 1 1 2.0944" centerOfRotation="%f %f %f"></viewpoint>\n',1.25*max(dim)+center(1),center(2),center(3),center);
return