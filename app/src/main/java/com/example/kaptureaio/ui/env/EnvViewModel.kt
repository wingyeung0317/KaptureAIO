package com.example.kaptureaio.ui.env

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel

class EnvViewModel : ViewModel() {

    private val _text = MutableLiveData<String>().apply {
        value = "This is 環境資訊 Fragment"
    }
    val text: LiveData<String> = _text
}