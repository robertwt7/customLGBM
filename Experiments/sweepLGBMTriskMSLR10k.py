import lightgbm as lgb
import numpy as np
import sklearn
import pandas as pd
from sklearn.datasets import load_svmlight_file
from sklearn.metrics import mean_squared_error
import riskrewardutil as rru

basePath = '/research/remote/petabyte/users/robert/Utilities/ltr-baseline/mslr10k/'
expPath = "/research/remote/petabyte/users/robert/LightGBM/Experiments/"
dataPath = basePath + 'dat/MSLR-WEB10K/'
modelPath = basePath + 'model/'
runPath = basePath + 'run/'
qrelsFile = dataPath + '../all.test.qrels'


#Count the amount of queries 
def group_counts(arr):
    d = np.ones(arr.size, dtype=int)
    d[1:] = (arr[:-1] != arr[1:]).astype(int)
    return np.diff(np.where(np.append(d, 1))[0])

name = "lgbm.2000.63.0.05.0.4.withTrisk"

combineddf = pd.DataFrame()
earlystop = [1000,1500,2000]

for stop in earlystop:
    combineddf = pd.DataFrame()
    name = name + '.earlystop%d' % (stop)
    for fold in range(1,6):
        suffix = name + ".fold%d" % (fold)

        X, y, qidtrain = load_svmlight_file(dataPath + 'Fold%d/train.txt' % (fold), query_id=True)
        train_data = lgb.Dataset(X, label=y, group=group_counts(qidtrain), free_raw_data=False)
        X_valid, y_valid, qidValid = load_svmlight_file(dataPath + 'Fold%d/vali.txt' % (fold), query_id=True)
        valid_data = lgb.Dataset(X_valid, label=y_valid, group=group_counts(qidValid), free_raw_data=False)
        valid_data.reference = train_data
        X_test, y_test, qid = load_svmlight_file(dataPath + 'Fold%d/test.txt' % (fold), query_id=True)
        test_data = lgb.Dataset(X_test, label=y_test, group=group_counts(qid), free_raw_data=False)

        #Global variables needed for custom metrics, qid and qrels for each valid file

        qidvalid= qidValid
        qrelsvalid = dataPath + 'Fold%d/vali.qrels' % (fold)
        qidtrain = qidtrain
        qrelstrain = dataPath + 'Fold%d/train.qrels' % (fold)
        #Another global variables containing bm25 features for each fold
        baselinename = 'resultsmslr10k/evalMetrics/baselinevalrun%d' % (fold)
        baselineeval = 'resultsmslr10k/evalMetrics/baselinevaleval%d' % (fold)
        baselinetrainname = 'resultsmslr10k/evalMetrics/baselinetrainrun%d' % (fold)
        baselinetraineval = 'resultsmslr10k/evalMetrics/baselinetraineval%d' % (fold)
        temppath = '/research/remote/petabyte/users/robert/LightGBM/Experiments/resultsmslr10k/evalMetrics/'

        metrics = rru.riskrewardUtil(qidvalid, qrelsvalid, baselinename, baselineeval, qidtrain, qrelstrain, baselinetrainname, baselinetraineval, temppath)

        eval_result = {}    
        #Setup Param File and generate different models for hyper parameter tuning
        param = {'num_leaves':63, 'num_trees':2000, 'objective':'lambdarank',
             'learning_rate': 0.05,'feature_fraction': 0.4,
             'bagging_fraction': 0.8,'bagging_freq': 5,
             'verbose': 1, 'early_stopping_rounds': stop}

        param['metric'] = 'None'
        #Train Model
        num_round = 10
        bst = lgb.train(param, train_data, num_round, valid_sets=[valid_data], feval=metrics.trisk1, evals_result=eval_result)
        bst.save_model(modelPath + suffix)

        combineddf = combineddf.append(metrics.predictgenerateRunFile(modelPath + suffix, runPath + suffix, X_test, qid))

        evals = pd.DataFrame.from_dict(eval_result)
        evals.to_csv(basePath + 'evaluation_result/' + suffix)

    combineddf.to_csv(runPath + 'run.all.' + name, index=False, header=None, sep=' ')
    #TO DO 
    #Get all the run file as 1 file, then eval them with evalScore
    metrics.evalScore(runPath + 'run.all.' + name, expPath + 'resultsmslr10k/evalPerQueryLGBMTriskes%d' % (stop), qrelsFile)


