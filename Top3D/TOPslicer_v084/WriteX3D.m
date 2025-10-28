function []=WriteX3D(NODE,FACE,filename,color,scale)

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
fprintf(stream,'    <Transform scale="%g %g %g">\n',scale*[1 1 1]);
fprintf(stream,'      <Shape>\n');
fprintf(stream,'        <Appearance>\n');
fprintf(stream,'          <Material diffuseColor="%.4f %.4f %.4f"/>\n',color);
fprintf(stream,'        </Appearance>\n');
% Face output
for i=1:size(FACE,1)
    if i==1
        fprintf(stream,'        <IndexedFaceSet solid="true" creaseAngle="3.141593" coordIndex="');
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
        fprintf(stream,'          <Coordinate point="');
        fprintf(stream,'%g %g %g ',NODE(i,:));
    elseif i==size(NODE,1)
        fprintf(stream,'%g %g %g"/>\n',NODE(i,:));
    else
        fprintf(stream,'%g %g %g ',NODE(i,:));
    end
end
fprintf(stream,'        </IndexedFaceSet>\n');
fprintf(stream,'      </Shape>\n');
fprintf(stream,'    </Transform>\n');

WritePostscript(stream);
fclose(stream);

function []=WritePreamble(stream,filename)
fprintf(stream,'<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(stream,'<!DOCTYPE X3D PUBLIC "ISO//Web3D//DTD X3D 3.2//EN" "http://www.web3d.org/specifications/x3d-3.3.dtd">\n');
fprintf(stream,'<X3D profile="Interchange" version="3.3" xmlns:xsd="http://www.w3.org/2001/XMLSchema-instance" xsd:noNamespaceSchemaLocation="http://www.web3d.org/specifications/x3d-3.3.xsd">\n');
fprintf(stream,'  <head>\n');
fprintf(stream,'    <meta content="%s" name="title"/>\n',filename);
fprintf(stream,'    <meta content="3D Topology --- exported from TOPslicer" name="description"/>\n');
fprintf(stream,'    <meta content="Tomas Zegard" name="creator"/>\n');
fprintf(stream,'    <meta content="%s" name="created"/>\n',date);
fprintf(stream,'  </head>\n');
fprintf(stream,'  <Scene>\n');
fprintf(stream,'    <Background groundColor="1 1 1" skyColor="1 1 1"/>\n');
return

function []=WritePostscript(stream)
fprintf(stream,'  </Scene>\n');
fprintf(stream,'</X3D>\n');
return

function []=WriteViewpoints(stream,LIM)
center = mean(LIM); dim = max(diff(LIM));
fprintf(stream,'    <Viewpoint description="ISO" position="%f %f %f" orientation="1.5 0.25 1 1" centerOfRotation="%f %f %f"/>\n',max(dim)/2+center(1),-max(dim)+center(2),max(dim)+center(3),center);
fprintf(stream,'    <Viewpoint description="TOP" position="%f %f %f" centerOfRotation="%f %f %f"/>\n',center(1),center(2),1.25*max(dim)+center(3),center);
fprintf(stream,'    <Viewpoint description="FRONT" position="%f %f %f" orientation="1 0 0 -1.5708" centerOfRotation="%f %f %f"/>\n',center(1),1.25*max(dim)+center(2),center(3),center);
fprintf(stream,'    <Viewpoint description="SIDE" position="%f %f %f" orientation="1 1 1 2.0944" centerOfRotation="%f %f %f"/>\n',1.25*max(dim)+center(1),center(2),center(3),center);
fprintf(stream,'    <Background skyColor="1 1 1"/>\n');
return