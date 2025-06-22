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

class DdayWidget1x1Provider : AppWidgetProvider() {
    
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateDdayWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        fun updateDdayWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
            val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            
            // SharedPreferences에서 D-Day 위젯 데이터 가져오기
            val ddayWidgets = DdayWidgetProvider.getDdayWidgets(prefs)
            
            // 첫 번째 D-Day 위젯 사용 (나중에 위젯별 설정 추가 가능)
            val widget = ddayWidgets.firstOrNull()
            
            val views = RemoteViews(context.packageName, R.layout.dday_widget_1x1)
            
            if (widget != null) {
                views.setTextViewText(R.id.dday_title, widget.title)
                
                // D-Day 계산
                val ddayText = calculateDday(widget.targetDate)
                views.setTextViewText(R.id.dday_count, ddayText)
                
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
                views.setTextViewText(R.id.dday_title, "D-Day 없음")
                views.setTextViewText(R.id.dday_count, "")
                views.setInt(R.id.dday_container, "setBackgroundColor", Color.WHITE)
                views.setTextColor(R.id.dday_title, Color.BLACK)
                views.setTextColor(R.id.dday_count, Color.BLACK)
            }
            
            // 앱을 열기 위한 인텐트 설정
            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            views.setOnClickPendingIntent(R.id.dday_container, pendingIntent)
            
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
        
        private fun calculateDday(targetDateString: String): String {
            return try {
                val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
                val targetDate = dateFormat.parse(targetDateString)
                val currentDate = Date()
                
                val diffInMillis = targetDate!!.time - currentDate.time
                val diffInDays = TimeUnit.MILLISECONDS.toDays(diffInMillis)
                
                when {
                    diffInDays > 0 -> "D-${diffInDays}"
                    diffInDays < 0 -> "D+${-diffInDays}"
                    else -> "D-Day"
                }
            } catch (e: Exception) {
                "D-Day"
            }
        }
    }
}