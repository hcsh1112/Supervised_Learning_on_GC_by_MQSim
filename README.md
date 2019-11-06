# Supervised_Learning_on_GC_in_MQSim
  Decreasing the overhead on the Garbage Collection of SSD by using Machine Learning(put it into practice by MQSim)

## [MQSim](https://github.com/CMU-SAFARI/MQSim)
  We use MQSim which is the SSD simulator by CMU to reach our goal. You can see information and parameters in MQSim by clicking the link.

### Motivation
  When the free space is lower than the threshold of GC, the SSD keeps doing GC operation. Moreover, there may have lots of valid pages of the victim block that is selected by the GC policy. The GC operation will take lots of time to copy the valid pages. Also, the read/write commands will be pended when the controller keeps doing GC operation. In the thesis, we want to apply the machine learning method to the GC mechanism. Collect the data in the FTL of SSD, data selection, data preprocessing and train the data by machine learning method. The machine learning model controls the GC mechanism and triggers the GC based on the prediction of the model. It is more flexible to trigger the GC than the original method that is triggering by the threshold. After applying the machine learning to trigger the GC operation, the GC operation can be delayed. It makes the valid pages more possibility to be invalid pages. Reducing the execution count and overhead of the GC.
  
### Architecture
  we also set two thresholds such as soft threshold and hard threshold. When the free space is less then the hard threshold, the garbage collection should be triggered immediately because the hard threshold means the least available space. When the free space is less than the soft threshold, we will ask the GC detector (that is trained by the supervised learning method) to predict whether the garbage collection should be executed.

### Collect training data from MQSim
  * Just following the instruction on MQSim website( parameters setting).
  * Choose the I/O Block trace you want(you can find [there](https://trace.camelab.org/index.html) or [IOTTA](http://iotta.snia.org/)
  * In __main.cpp__, you can find `fs.open("output.txt", fstream::out);` it can document your training data that you want into output.txt
  * In __/ssd/GC_and_WL_Unit_Page_Level.cpp__, the __Check_gc_required()__ function. Once the write command comes, the `Check_gc_required()` will be triggered. You can modify the code to get your machine learning features in FTL.
  
In __/ssd/GC_and_WL_Unit_Page_Level.cpp__
  ```cpp
  else if ( free_block_pool_size < 102 ) {
  } // else if

  else if ( predict_one_C(obj, Simulator->Time() , \
    percent_of_invalid, percent_of_valid, percent_of_free, block
  } // else if

  else // predict don't execute gc and still have more than op space
    return;
  ```
  Please __comment__ this code while you're collecting the training data
  
### Machine Learning 
  * TBD
  
### Cython, Link Python to C++
  * TBD

  
