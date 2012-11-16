%> @ingroup guigroup
%> @file
%> @brief Calls Properties GUIs for all component blocks
%
%> @param blk instance of block to be created
%> @param ?
function varargout = uip_block_cascade_base(varargin)
blk = varargin{1};
input = [];
if nargin >= 1
    input = varargin{2};
end;
output.flag_ok = 0;
output.params = {};

no_blocks = numel(blk.blocks);
params = {};
for i = 1:no_blocks
    z = blk.blocks{i}.get_params(input);
    
    if ~z.flag_ok
        break;
    end;
    
    if isfield(z, 'params') % bit of tolerance
        for j = 1:2:numel(z.params)
            z.params{j} = ['blocks{', int2str(i), '}.', z.params{j}];
        end;
        params = [params, z.params]; % Goes collecting params
    end;
    
    if i == no_blocks
        output.flag_ok = 1;
        output.params = params;
    end;
end;


















varargout{1} = output;
