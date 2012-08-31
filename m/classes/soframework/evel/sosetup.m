%> This is a property repository
%>
%> What you are going to do with this output structure, it is entirely your choice!
classdef sosetup
    properties
        %> Manifests an intention to go parallel
        flag_parallel = NaN;

        flag_skip_existing = NaN;

        
        stabnumber = 10;
        
        %> ='single'. Possible values: 'single'; 'ovr'-"One-Versus-Reference". The operation of this will depend on the particular implementation,
        %> and many sostages will ignore this. Actually this is something that will work for the sostages that produce biomarkers, only
        splittype = NaN;
    
        %> ='rates'. Recording to base the choice on
        ratesname = NaN;
        
        %> randomseed for the undersampling sgs
        under_randomseed = NaN;
        
        %> a dataloader_she object (that needs to be tuned for the specific dataset classes (NT/NDI/Trai))
        dataloader;
        
        %> a subdatasetprovider object containing only one subdataset percentage: 100%!
        subdatasetprovider;
        
        %> a sostage_pp object (currently Rubberband -> Amide I normalization) that can be used to retrieve a Pre-processing when needed
        sostage_pp;
        
        %> a sostage_fe object (currently PLS - partial Least Squares) that can be used to retrieve a feature extractor to be used for classifier design
        sostage_fe;

        %> a sostage_cl object (currently LDC) 
        sostage_cl;
        
        %> a cubeprovider object with 10 reps, NOT parallel, with 0 randomseed, and, perhaps most important: a DEFAULT
        %>      TTLOGPROVIDER of @ref ttlogprovider class (other classifiers, such as FRBM or SVM would like to use a custom logprovider)
        cubeprovider;
        
        %> chooser object to be used for "results reduction" (Example: @ref ropr_1perarch objects
        clarchsel_chooser;
        
        %> Chooser for the algorithm-independent design
        undersel_chooser;

        %> chooser object to be used for the Feature Extraction Design step
        fearchsel_chooser;

        %> chooser object to be used for final single choice.
        diacomp_chooser;

        
        pand_chooser;
        
        % (model/stage)-specific design properties
        % All properties are initialized to NaN to make sure that they won't be forgotten, any subsequent attempt to use them will give an error
        
        
        % ANN properties
        clarchsel_ann_nfs = NaN;;
        clarchsel_ann_archs = NaN;
        undersel_ann_unders = NaN;
        
        
        % SVM properties
        %> Design property: list of prospective C's
        clarchsel_svm_nfs = NaN;
        clarchsel_svm_cs = NaN;
        %> Design property: list of prospective gamma's
        clarchsel_svm_gammas = NaN;
        undersel_svm_unders = NaN;
        
        
        % FRBM properties
        %> (Design property) Different scales to try
        clarchsel_frbm_scales = NaN;
        clarchsel_frbm_nfs = NaN;
        undersel_frbm_unders = NaN;


        % KNN properties
        clarchsel_knn_nfs = NaN;
        clarchsel_knn_ks = NaN;
        undersel_knn_unders = NaN;

        % LASSO properties
        undersel_lasso_unders = NaN;
        clarchsel_lasso_nfs = NaN;

            

        % LDC properties
%         clarchsel_ldc_nfs = NaN;
        undersel_ldc_unders = NaN;

        % QDC properties
%         clarchsel_qdc_nfs = NaN;
        undersel_qdc_unders = NaN;


        % LS properties
%         clarchsel_ls_nfs = NaN;
        undersel_ls_unders = NaN;

        % LS properties
        clarchsel_lsth_nfs = NaN;
        undersel_lsth_unders = NaN;

        % DIST properties
%         clarchsel_dist_nfs = NaN;
        undersel_dist_unders = NaN;
        
        
        % FEARCHSEL_FFS
        fearchsel_ffs_nf_max = NaN;
        fearchsel_manova_nf_max = NaN;
        fearchsel_fisher_nf_max = NaN;
        fearchsel_lasso_nf_max = NaN;
        

        fearchsel_pca_nfs = NaN;
        fearchsel_pls_nfs = NaN;
        
        fearchsel_fhana_nf_max = NaN;

        fearchsel_spline_nfs = NaN;
        
        
        lcr2_no_folds = NaN;
        lcr2_subdspercs = NaN;
        
        fhg_ffs_nf_select = NaN;
        fhg_lasso_nf_select = NaN;
        fhg_manova_nf_select = NaN;
        fhg_fisher_nf_select = NaN;
        fhg_pcalda_nf_select = NaN;
        fhg_lda_nf_select = NaN;
        
        fhg_pcalda_no_factors = NaN;
    end;

    methods
        %> Constructor
        function o = sosetup()
            o.flag_parallel = 0;

            o.splittype = 'single';

            o.ratesname = 'rates';            

            o.under_randomseed = 0;

            
            
            %-----
            %----- Data loader setup
            %-----
            dl = []; %dataloader();
            o.dataloader = dl;

            %=== Subdataset Provider setup
            %===
            sdp = subdatasetprovider();
            sdp.subdspercs = [1];
            sdp.randomseed = 0;
            o.subdatasetprovider = sdp;

            
            %=== Pre-processing sostage_pp
            %===
            spp = sostage_pp_rubbernorm();
            spp.ndec = 1;  % Note that the default is to decimate once!
            spp.norm_types = '1';
            o.sostage_pp = spp;


            %=== Feature Extraction sostage_fe setup
            %===
%             sfe = sostage_fe_pls();
%             sfe.nf = 10; % Arbitrary
            sfe = sostage_fe_bypass();
            o.sostage_fe = sfe;
            
            
            %=== Feature Extraction sostage_fe setup
            %===
            scl = sostage_cl_ldc();
            scl.flag_cb = 1;
            o.sostage_cl = scl;
            

            %=== Cubeprovider setup
            %===
            cp = cubeprovider(); %#ok<*CPROP,*PROP>
            cp.no_reps = 10;            
            cp.no_reps_fhg = 10;
            cp.no_reps_stab = 1;
            cp.flag_parallel = 0;
            cp.randomseed = 0;
            cp.randomseed_stab = 1928396; % arbitrary number
            cp.ttlogprovider = ttlogprovider();
            o.cubeprovider = cp;
            
            %====== Setup for various classifiers
            %====== 
            
            %=== Unders setup
            %===
            UNDERS = [1, 2, 3, 4, 5, 7, 9];
            
            o.undersel_ann_unders = UNDERS;
            o.undersel_svm_unders = UNDERS;
            o.undersel_knn_unders = UNDERS;
            o.undersel_ldc_unders = UNDERS;
            o.undersel_qdc_unders = UNDERS;
            o.undersel_frbm_unders = UNDERS;
            o.undersel_lasso_unders = UNDERS;
            o.undersel_ls_unders = UNDERS;
            o.undersel_lsth_unders = UNDERS;

            
            o.clarchsel_ann_nfs = [3, 5, 10, 20, 50, 100];
            o.clarchsel_ann_archs = {[1], [3], [5], [10], [15], [20], [30], [7, 4], [10, 5], [10, 9], [20, 11]};  %#ok<*NBRAK>
        
        
            % Data Analysis Stage-independent
            o.clarchsel_knn_nfs = [3, 5, 7, 9, 11, 13, 15, 20, 25, 30, 35, 50];
            o.clarchsel_knn_ks = [1, 2, 3, 5, 7, 11, 13, 15, 17];

            
            o.clarchsel_lasso_nfs = [1, 2, 3, 5:2:15, 18:3:36, 40:4:152];

            o.clarchsel_svm_nfs = [7, 10, 15, 30, 50, 100];
            o.clarchsel_svm_cs = 10.^(2:.25:5);
            o.clarchsel_svm_gammas = 10.^(-7:.5:-1);

            
            o.fearchsel_ffs_nf_max = 50;
            o.fearchsel_manova_nf_max = 50;
            o.fearchsel_fisher_nf_max = 50;
            o.fearchsel_lasso_nf_max = 50;
            
            o.fearchsel_fhana_nf_max = 50;
            
%             o.clarchsel_frbm_nfs = [3, 5, 10, 15, 20, 25, 30, 50, 100];
%             o.clarchsel_frbm_scales = 1; % No need to try different scales for FRBM
            
%             o.clarchsel_dist_nfs = [3, 5, 10, 15, 20, 25, 30, 35, 40];

%             o.fearchsel_lasso_nfs = 3:3:81;
            
            o.fearchsel_pca_nfs = [1:9, 11:2:151];
            o.fearchsel_pls_nfs = [1:9, 11:2:151];
            
%             o.clarchsel_ldc_nfs = [3, 5, 10, 15, 20, 25, 30, 35, 40];
% 
%             o.clarchsel_qdc_nfs = [3, 5, 10, 15, 20, 25, 30, 35, 40];
% 
%             o.clarchsel_ls_nfs = [3, 5, 10, 15, 20, 25, 30, 35, 40];
% 
%             o.clarchsel_dist_nfs = [3, 5, 10, 15, 20, 25, 30, 35, 40];
% 
%             o.clarchsel_lsth_nfs = 3:3:81;
            
            o.lcr2_no_folds = 50;
            o.lcr2_subdspercs = [.1, .15, .2:.1:1];
            
            o.fearchsel_spline_nfs = 6:70;
            
            o.fhg_ffs_nf_select = 10;
            o.fhg_lasso_nf_select = 10;
            o.fhg_manova_nf_select = 10;
            o.fhg_fisher_nf_select = 10;
            o.fhg_pcalda_nf_select = 10;
            o.fhg_lda_nf_select = 10;

          
            
            %=== Choosers setup
            %===
            
            %-----
            %----- Chooser CLARCHSEL1
            %-----
            ch1 = chooser();
            ch1.rate_maxloss = .01; % 1% default
            ch1.time_pvalue = 0.05;
            ch1.time_mingain = .25; % 25% default
            ch1.vectorcomp = vectorcomp_ttest_right();
            ch1.vectorcomp.flag_logtake = 0;


            %-----
            %----- Chooser UNDERSEL
            %-----
            ch2 = chooser();
            ch2.rate_maxloss = .01;
            ch2.time_pvalue = 0.05;
            ch2.time_mingain = .25;
            ch2.vectorcomp = vectorcomp_ttest_right();
            ch2.vectorcomp.flag_logtake = 0;
            
            %-----
            %----- Chooser UNDERSEL
            %-----
            ch3 = chooser();
            ch3.rate_maxloss = .01;
            ch3.time_pvalue = 0.05;
            ch3.time_mingain = .25;
            ch3.vectorcomp = vectorcomp_ttest_right();
            ch3.vectorcomp.flag_logtake = 0;
            
          
            %-----
            %----- Chooser CROSS
            %-----
            ch4 = chooser_notime();
            

            % Conservative chooser
            cc = ch3;
            cc.rate_maxloss = 0.002;
            
            
            
            o.clarchsel_chooser = ch1;
            o.undersel_chooser = ch2;
            o.fearchsel_chooser = ch3;
            o.diacomp_chooser = cc;
            o.pand_chooser = cc;


            o = o.setup_from_env();
        end;


        
        %> Sets up properties according to the current directory
        %> Sets up some properties according to environment variables FLAG_PARALLEL and FLAG_SKIP_EXISTING
        function o = setup_from_env(o)
            % Checks whether it is possible to parallelize
            % primary information about parallelization will be the FLAG_PARALLEL environment variable
            flag = getenv('FLAG_PARALLEL');
            flag = ~isempty(flag) && str2double(flag); 
            flag = flag && license('test', 'distrib_computing_toolbox');
            o.flag_parallel = flag;

            sflag = getenv('FLAG_SKIP_EXISTING');
            if ~isempty(sflag)
                o.flag_skip_existing = str2double(sflag);
            else
                o.flag_skip_existing = 1;
            end;
        end;
    end;
end

