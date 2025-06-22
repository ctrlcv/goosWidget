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

class MemoWidget1x1Provider : AppWidgetProvider() {
    
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateMemoWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        fun updateMemoWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
            val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            
            // SharedPreferences에서 메모 위젯 데이터 가져오기
            val memoWidgets = MemoWidgetProvider.getMemoWidgets(prefs)
            
            // 첫 번째 메모 위젯 사용 (나중에 위젯별 설정 추가 가능)
            val widget = memoWidgets.firstOrNull()
            
            val views = RemoteViews(context.packageName, R.layout.memo_widget_1x1)
            
            if (widget != null) {
                views.setTextViewText(R.id.memo_content, widget.content)
                
                // 배경색 설정
                try {
                    val backgroundColor = Color.parseColor(widget.backgroundColor)
                    views.setInt(R.id.memo_container, "setBackgroundColor", backgroundColor)
                } catch (e: Exception) {
                    views.setInt(R.id.memo_container, "setBackgroundColor", Color.WHITE)
                }
                
                // 텍스트 색상 설정
                try {
                    val textColor = Color.parseColor(widget.textColor)
                    views.setTextColor(R.id.memo_content, textColor)
                } catch (e: Exception) {
                    views.setTextColor(R.id.memo_content, Color.BLACK)
                }
            } else {
                views.setTextViewText(R.id.memo_content, "메모 없음")
                views.setInt(R.id.memo_container, "setBackgroundColor", Color.WHITE)
                views.setTextColor(R.id.memo_content, Color.BLACK)
            }
            
            // 앱을 열기 위한 인텐트 설정
            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            views.setOnClickPendingIntent(R.id.memo_container, pendingIntent)
            
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}