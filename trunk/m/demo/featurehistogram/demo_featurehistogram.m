% Demonstrates the generation of a Feature Histogram

% The dataset
ds = load_data_she5trays();
ds = data_select_hierarchy(ds, 2); % Classes: N/T

% The classifier
o = clssr_cla();
o.type = 'linear';
clssr_cla01 = o;

% The FSG
o = fsg_clssr();
o.clssr = clssr_cla01;
o.estlog = [];
o.postpr_est = [];
o.postpr_test = [];
o.sgs = [];
fsg_clssr01 = o;

% The object that will do the feature selection
ofs = as_fsel_forward();
ofs.data = ds;
ofs.nf_select = 10; % <-------- Number of features to be selected
ofs.fsg = fsg_clssr01;

% The SGS
osgs = sgs_randsub();
osgs.flag_group = 0;
osgs.flag_perclass = 0;
osgs.randomseed = 0;
osgs.no_reps = 50; % <-------- Number of repetitions for the histogram

% The Feature Selection Repeater
orep = fselrepeater();
orep.sgs = osgs;
orep.as_fsel = ofs;
orep.data = ds;

log_rep = orep.go(); % This is the time-consuming line

%%

%> Stability and nf x grade

ds_nfxgrade = log_rep.extract_dataset_nfxgrade();
ds_stab = log_rep.extract_dataset_stabilities();

ov = vis_alldata();

figure;
subplot(1, 2, 1);
ov.use(ds_nfxgrade);
legend off;
subplot(1, 2, 2);
ov.use(ds_stab);
legend off;

maximize_window(gcf(), 4);
%%

ssp = subsetsprocessor();

% Plots histogram in 3 different styles
figure;
for i = 1:3
    if i == 1
        %> All features are informative
        ssp.nf4grades = [];
        ssp.nf4gradesmode = 'fixed';
        colors = {'jet', [.7, .7, .7]};
    elseif i == 2
        %> Number of informative features calculated by stability threshold
        ssp.nf4grades = 4;
        ssp.nf4gradesmode = 'fixed';
        ssp.stabilitythreshold = 0.05;
        colors = {'jet', [.7, .7, .7]};
    elseif i == 3
        %> Same as previous but with different color scheme
        ssp.nf4grades = 4;
        ssp.nf4gradesmode = 'fixed';
        ssp.stabilitythreshold = 0.05;
        colors = {[.6, 0, 0], [1, 0, 0], [.7, .7, .7], [.9, .9, .9]};
    end;
    log_ssp = ssp.use(log_rep);
    
    subplot(3, 1, i);
    log_ssp.draw_stackedhists(ds, colors, []);
    freezeColors();
end;
maximize_window(gcf(), 1.5);











