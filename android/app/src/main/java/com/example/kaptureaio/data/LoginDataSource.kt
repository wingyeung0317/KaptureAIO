package com.example.kaptureaio.data

import android.util.Log
import com.example.kaptureaio.data.model.LoggedInUser
import io.ktor.client.*
import io.ktor.client.call.body
import io.ktor.client.engine.android.*
import io.ktor.client.request.*
import io.ktor.client.statement.*
import java.io.IOException
import kotlinx.coroutines.*

/**
 * Class that handles authentication w/ login credentials and retrieves user information.
 */
class LoginDataSource {

    fun login(username: String, password: String): Result<LoggedInUser> {
        try {
            // TODO: handle loggedInUser authentication
            val test = connectLoginDB()
            Log.d("login", "login: $test")
            val fakeUser = LoggedInUser(java.util.UUID.randomUUID().toString(), "Jane Doe")
            return Result.Success(fakeUser)
        } catch (e: Throwable) {
            return Result.Error(IOException("Error logging in", e))
        }
    }

    fun connectLoginDB(): (String?){
        val client = HttpClient(Android)
        val responseString:String
        try {
            runBlocking {
                val response = client.post("http://192.168.1.100:5000/connect") {
                    // Configure request parameters exposed by HttpRequestBuilder
                    setBody("test")
                }
                responseString = response.body<String>()
            }
            return responseString
        } catch (e: Throwable) {
            Log.d("login", "connectLoginDB: $e")
            return null
        }
    }

    fun logout() {
        // TODO: revoke authentication
    }
}