package com.foriton.gooswidget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Color
import android.widget.RemoteViews
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.*
import java.util.concurrent.TimeUnit

class DdayWidgetProvider : AppWidgetProvider() {
    
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateDdayWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        fun updateDdayWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
            val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            
            // SharedPreferences에서 D-Day 위젯 데이터 가져오기
            val ddayWidgets = getDdayWidgets(prefs)
            
            // 첫 번째 D-Day 위젯 사용 (나중에 위젯별 설정 추가 가능)
            val widget = ddayWidgets.firstOrNull()
            
            val views = RemoteViews(context.packageName, R.layout.dday_widget)
            
            if (widget != null) {
                views.setTextViewText(R.id.dday_title, widget.title)
                views.setTextViewText(R.id.dday_count, calculateDday(widget.targetDate))
                
                // 배경색 설정
                try {
                    val backgroundColor = Color.parseColor(widget.backgroundColor)
                    views.setInt(R.id.dday_container, "setBackgroundColor", backgroundColor)
                } catch (e: Exception) {
                    views.setInt(R.id.dday_container, "setBackgroundColor", Color.WHITE)
                }
                
                // 텍스트 색상 설정
                try {
                    val textColor = Color.parseColor(widget.textColor)
                    views.setTextColor(R.id.dday_title, textColor)
                    views.setTextColor(R.id.dday_count, textColor)
                } catch (e: Exception) {
                    views.setTextColor(R.id.dday_title, Color.BLACK)
                    views.setTextColor(R.id.dday_count, Color.BLACK)
                }
            } else {
                views.setTextViewText(R.id.dday_title, "D-Day를 추가해주세요")
                views.setTextViewText(R.id.dday_count, "")
                views.setInt(R.id.dday_container, "setBackgroundColor", Color.WHITE)
                views.setTextColor(R.id.dday_title, Color.BLACK)
                views.setTextColor(R.id.dday_count, Color.BLACK)
            }
            
            // 앱 열기 인텐트
            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent, 
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.dday_container, pendingIntent)
            
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
        
        private fun getDdayWidgets(prefs: SharedPreferences): List<DdayWidgetData> {
            val widgetsJson = prefs.getString("flutter.dday_widgets", null)
            val widgets = mutableListOf<DdayWidgetData>()
            
            if (widgetsJson != null) {
                try {
                    val jsonArray = JSONArray(widgetsJson)
                    for (i in 0 until jsonArray.length()) {
                        val jsonObject = jsonArray.getJSONObject(i)
                        widgets.add(
                            DdayWidgetData(
                                id = jsonObject.getString("id"),
                                title = jsonObject.getString("title"),
                                targetDate = jsonObject.getString("targetDate"),
                                backgroundColor = jsonObject.getString("backgroundColor"),
                                textColor = jsonObject.getString("textColor")
                            )
                        )
                    }
                } catch (e: Exception) {
                    // JSON 파싱 오류 무시
                }
            }
            
            return widgets
        }
        
        private fun calculateDday(targetDateStr: String): String {
            return try {
                val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
                val targetDate = sdf.parse(targetDateStr)
                val today = Calendar.getInstance()
                today.set(Calendar.HOUR_OF_DAY, 0)
                today.set(Calendar.MINUTE, 0)
                today.set(Calendar.SECOND, 0)
                today.set(Calendar.MILLISECOND, 0)
                
                if (targetDate != null) {
                    val diffInMillis = targetDate.time - today.timeInMillis
                    val diffInDays = TimeUnit.MILLISECONDS.toDays(diffInMillis).toInt()
                    
                    when {
                        diffInDays > 0 -> "D-$diffInDays"
                        diffInDays < 0 -> "D+${-diffInDays}"
                        else -> "D-Day"
                    }
                } else {
                    "D-Day"
                }
            } catch (e: Exception) {
                "D-Day"
            }
        }
    }
}

data class DdayWidgetData(
    val id: String,
    val title: String,
    val targetDate: String,
    val backgroundColor: String,
    val textColor: String
)