%> Compares a list of Diagnosis Systems
%>

classdef diacomp < sodesigner
    methods
        %> Gives an opportunity to change somethin inside the item
        function item = process_item(o, item)
        end;
        
        function o = customize(o)
            o = customize@sodesigner(o);
            o.portion = 'complement';
        end;
    end;
    
    % Bit lower level
    methods(Access=protected)
        %> Item must be a soitem_diaa
        %>
        %> The cell of diagnosissystem objects inside item can be nD, diacomp doesn't care
        function out = do_design(o)
            item = o.process_item(item);
            
            si = size(item.diaa);
            
            ni = numel(item.diaa);
            
            molds = cell(si);
            titles = cell(si);
            for i = 1:ni
                molds{i} = item.diaa{i}.get_block();
                ti = item.diaa{i}.title;
                titles{i} = [iif(~isempty(ti), [ti, ', '], ''), item.diaa{i}.get_sequencedescription()];
            end;
            
            
            cube = o.oo.cubeprovider.get_cube(ds);
            cube.data = ds;
            cube.block_mold = molds;
            cube = cube.go();
            
            sor = sovalues();
            sor = sor.read_log_cube(cube, []);
            sor.chooser = o.oo.diacomp_chooser;
            sor = sor.set_field('title', titles);
            sor = sor.set_field('dia', item.diaa);

            
% % % %             cube = o.oo.cubeprovider.get_cube(ds);
% % % %             cube.data = ds;
% % % %             cube.block_mold = molds;
% % % %             cube = cube.go();
% % % %             
% % % %             sor = sovalues();
% % % %             sor = sor.read_log_cube(cube, []);
% % % %             sor.chooser = o.chooser;
% % % %             sor = sor.set_field('dia', item.diaa);
% % % %             sor = sor.set_field('title', titles);
            
            sor.ax = item.ax;
            
            out = soitem_diachoice();
            out.sovalues = sor;
        end;
    end;
end
